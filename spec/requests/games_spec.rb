# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Games", type: :request do
  describe "GET /games" do
    subject(:do_request) { get "/games" }

    let(:user) { create(:user) }

    before do
      sign_in user if user.present?
    end

    context "when the are some games assotiate to the user" do
      let(:game1) { create(:game) }
      let(:game2) { create(:game) }

      before do
        create(:game_user, game: game1, user:)
        create(:game_user, game: game2, user:)
      end

      it "renders the page" do
        do_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Games")
        expect(response.body).to include("Add new game")
      end

      it "renders games title" do
        do_request

        expect(response.body).to include(game1.name)
        expect(response.body).to include(game1.name)
      end
    end

    context "when the user does not have any associated games" do
      it "renders the page" do
        do_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Games")
        expect(response.body).to include("Add new game")
      end

      it "renders games title" do
        do_request

        expect(response.body).to include("You have not added games for tracking yet.")
      end
    end

    context "when the user in not logged in" do
      let(:user) { nil }

      it "renders dashboard with logout button" do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /games/new" do
    subject(:do_request) { get "/games/new" }

    let(:steam_api_client) do
      instance_double(Steam::ApiClient, games:)
    end

    let(:user) { create(:user) }

    let(:games) do
      [
        {"appid" => 1, "name" => "Game 1"},
        {"appid" => 2, "name" => "Game 2"},
      ]
    end

    before do
      allow(Steam::ApiClient).to receive(:new)
        .with(user)
        .and_return(steam_api_client)
    end

    context "when the user is logged in" do
      before do
        sign_in user
      end

      it "renders the page" do
        do_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Add new game")
      end

      context "when there are not games which can be added" do
        let(:games) { [] }

        it "renders error message" do
          do_request

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include("Sorry, there are not games which can be added for tracking.")
        end
      end
    end

    context "when the user is not logged in" do
      it "renders dashboard with logout button" do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /games" do
    subject(:do_request) { post "/games", params: {games_add_form: games_params} }

    let(:games_params) do
      {
        app_uid:,
      }
    end

    let(:user) { create(:user) }
    let(:app_uid) { Faker::Crypto.md5 }

    let(:api_client) { instance_double(Steam::ApiClient, games: steam_games) }
    let(:store_client) { instance_double(Steam::StoreClient) }

    let(:steam_games) do
      [
        {"appid" => Faker::Crypto.md5},
        {"appid" => app_uid},
        {"appid" => Faker::Crypto.md5},
        {"appid" => Faker::Crypto.md5},
      ]
    end

    let(:game_info) do
      {
        "name" => Faker::App.name,
        "header_image" => Faker::Internet.url,
      }
    end

    let(:achievements_info) do
      [api_achievemt_params(attributes_for(:achievement)), api_achievemt_params(attributes_for(:hidden_achievement))]
    end

    let(:user_achievements_info) do
      achievements_info.to_a.map do |info|
        completed = [true, false].sample

        {
          "apiname" => info["name"],
          "achieved" => completed ? 1 : 0,
          "unlocktime" => completed ? Faker::Time.backward(days: rand(1..1_000)).to_i : 0,
        }
      end
    end

    before do
      sign_in user if user.present?

      allow(Steam::ApiClient).to receive(:new)
        .with(user)
        .and_return(api_client)

      allow(Steam::StoreClient).to receive(:new)
        .and_return(store_client)

      allow(store_client).to receive(:game_info)
        .with(app_uid)
        .and_return(game_info)

      allow(api_client).to receive(:achievements_info)
        .with(app_uid)
        .and_return(achievements_info)

      allow(api_client).to receive(:achievements)
        .with(app_uid)
        .and_return(user_achievements_info)
    end

    context "when the game has not been added before" do
      let(:created_game) { Game.last }

      it "creates a new game" do
        expect { do_request }.to change { Game.count }.by(1)
        expect(created_game.app_uid).to eq app_uid
        expect(created_game.name).to eq game_info["name"]
        expect(created_game.image).to eq game_info["header_image"]
      end

      it "creates achievements for the game" do
        expect { do_request }.to change { Achievement.count }.by(achievements_info.length)

        achievements_info.each do |info|
          achievement = created_game.achievements.find_by(uid: info["name"])
          expect(achievement).to be_present
          expect(achievement.name).to eq info["displayName"]
        end
      end

      it "renders confirmation form with created status" do
        do_request

        expect(response).to have_http_status(:created)
        expect(response.body).to include("Would you like to add this game for tracking achievements?")
        expect(response.body).to include(created_game.name)
      end

      it "does not add game to user games" do
        expect { do_request }.not_to change { user.reload.games.count }
      end
    end

    context "when the game has been added to the system before but not for the user" do
      let!(:game) { create(:game) }
      let(:app_uid) { game.app_uid }

      let(:achievements_info) do
        [api_achievemt_params(old_achievement), new_achievement_info]
      end

      let(:old_achievement) { create(:achievement, game:) }
      let(:new_achievement_info) { api_achievemt_params(attributes_for(:achievement)) }

      it "does not create a new game and update current game info" do
        expect { do_request }.not_to change { Game.count }

        expect(game.reload.name).to eq game_info["name"]
        expect(game.image).to eq game_info["header_image"]
      end

      it "creates only new achievements for the game" do
        expect { do_request }.to change { game.reload.achievements.count }.by(1)
        expect(game.achievements.count).to be 2

        achievement = game.achievements.find_by(uid: new_achievement_info["name"])
        expect(achievement).to be_present
        expect(achievement.name).to eq new_achievement_info["displayName"]
      end

      it "renders confirmation form with ok status" do
        do_request

        expect(response).to have_http_status(:created)
        expect(response.body).to include("Would you like to add this game for tracking achievements?")
        expect(response.body).to include(game_info["name"])
      end

      it "does not add game to user games" do
        expect { do_request }.not_to change { user.reload.games.count }
      end
    end

    context "when game has been already added for the user" do
      let(:game) { create(:game) }
      let(:app_uid) { game.app_uid }

      before do
        create(:game_user, game:, user:)
      end

      it "renders form with error message" do
        do_request

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when app uid is not valid" do
      let(:steam_games) do
        [
          {"appid" => Faker::Crypto.md5},
          {"appid" => Faker::Crypto.md5},
          {"appid" => Faker::Crypto.md5},
        ]
      end

      it "renders form with error message" do
        do_request

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when app uid is not pass" do
      let(:app_uid) { "" }

      it "renders form with error message" do
        do_request

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when the user is not logged in" do
      let(:user) { nil }

      it "renders dashboard with logout button" do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /games/:id/accept" do
    subject(:do_request) { post "/games/#{game_id}/accept" }

    let(:user) { create(:user) }
    let(:game) { create(:game) }
    let(:game_id) { game.id }

    before do
      sign_in user if user.present?
    end

    context "when game can be added" do
      it "redirects to games list path" do
        do_request

        expect(response).to redirect_to(games_path)
      end

      it "adds game for the user" do
        expect { do_request }.to change { user.reload.games.count }.by(1)
        expect(user.games.last).to eq game
      end

      context "when the game has some achievements" do
        let(:count) { rand(3..5) }

        let(:achievements) do
          Array.new(count) do
            create(:achievement, game:)
          end
        end

        let(:achievements_info) do
          achievements.map do |record|
            {
              "apiname" => record.uid,
              "achieved" => [0, 1].sample,
              "unlocktime" => Faker::Time.backward(days: rand(1..100)).to_i,
            }
          end
        end

        let(:steam_api_client) do
          instance_double(Steam::ApiClient)
        end

        before do
          allow(Steam::ApiClient).to receive(:new)
            .with(user)
            .and_return(steam_api_client)

          allow(steam_api_client).to receive(:achievements)
            .with(game.app_uid)
            .and_return(achievements_info)
        end

        it "adds achievements progress for the user game" do
          expect { do_request }.to change { AchievementUser.count }.by(count)
          expect(user.game_users.find_by(game:).achievement_users.count).to eq count
        end
      end
    end

    context "when the game is not found" do
      let(:game_id) { "fake" }

      it "renders dashboard with logout button" do
        do_request

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the user in not logged in" do
      let(:user) { nil }

      it "renders dashboard with logout button" do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
