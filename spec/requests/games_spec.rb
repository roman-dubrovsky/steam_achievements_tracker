require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "Get /games" do
    subject(:do_request) { get "/games" }

    let(:user) { create(:user) }

    before do
        sign_in user if user.present?
      end

    context 'when the user is logged in' do
      # Todo: Add tests

      it "renders the page" do
        do_request

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user in not logged in' do
      let(:user) { nil }

      it 'renders dashboard with logout button' do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /games/new" do
    subject(:do_request) { get "/games/new" }

    let(:steam_api_client) do
      instance_double(Steam::ApiClient, games: games)
    end

    let(:user) { create(:user) }

    let(:games) do
      [
        { "appid" => 1, "name" => "Game 1" },
        { "appid" => 2, "name" => "Game 2" }
      ]
    end

    before do
      allow(Steam::ApiClient).to receive(:new)
        .with(user)
        .and_return(steam_api_client)
    end

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it "renders the page" do
        do_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Add new game")
      end

      context 'when there are not games which can be added' do
        let(:games) { [] }

        it "renders error message" do
          do_request

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include("Sorry, there are not games which can be added for tracking.")
        end
      end
    end

    context 'when the user is not logged in' do
      it 'renders dashboard with logout button' do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "Post /games" do
    subject(:do_request) { post "/games", params: { games_add_form: games_params } }

    let(:games_params) do
      {
        app_uid: app_uid
      }
    end

    let(:user) { create(:user) }
    let(:app_uid) { Faker::Crypto.md5 }

    let(:api_client) { instance_double(Steam::ApiClient, games: steam_games) }
    let(:store_client) { instance_double(Steam::StoreClient) }

    let(:steam_games) do
      [
        { "appid" => Faker::Crypto.md5 },
        { "appid" => app_uid },
        { "appid" => Faker::Crypto.md5 },
        { "appid" => Faker::Crypto.md5 }
      ]
    end

    let(:game_info) do
      {
        "name" => Faker::App.name,
        "header_image" => Faker::Internet.url
      }
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
    end

    context 'when the game has not been added before' do
      let(:created_game) { Game.last }

      it 'creates a new game' do
        expect { do_request }.to change { Game.count }.by(1)
        expect(created_game.app_uid).to eq app_uid
        expect(created_game.name).to eq game_info["name"]
        expect(created_game.image).to eq game_info["header_image"]
      end

      it 'renders confirmation form with created status' do
        do_request

        expect(response).to have_http_status(:created)
        expect(response.body).to include("Would you like to add this game for tracking achievements?")
        expect(response.body).to include(created_game.name)
      end

      it 'does not add game to user games' do
        expect { do_request }.not_to change { user.reload.games.count }
      end
    end

    context 'when the game has been added to the system before but not for the user' do
      let!(:game) { create(:game) }
      let(:app_uid) { game.app_uid }

      it 'does not create a new game and update current game info' do
        expect { do_request }.not_to change { Game.count }

        expect(game.reload.name).to eq game_info["name"]
        expect(game.image).to eq game_info["header_image"]
      end

      it 'renders confirmation form with ok status' do
        do_request

        expect(response).to have_http_status(:created)
        expect(response.body).to include("Would you like to add this game for tracking achievements?")
        expect(response.body).to include(game_info["name"])
      end

      it 'does not add game to user games' do
        expect { do_request }.not_to change { user.reload.games.count }
      end
    end

    context 'when game has been already added for the user' do
      let(:game) { create(:game) }
      let(:app_uid) { game.app_uid }

      before do
        create(:game_user, game: game, user: user)
      end

      it 'renders form with error message' do
        do_request

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when app uid is not valid' do
      let(:steam_games) do
        [
          { "appid" => Faker::Crypto.md5 },
          { "appid" => Faker::Crypto.md5 },
          { "appid" => Faker::Crypto.md5 }
        ]
      end

      it 'renders form with error message' do
        do_request

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when app uid is not pass' do
      let(:app_uid) { "" }

      it 'renders form with error message' do
        do_request

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when the user is not logged in' do
      let(:user) { nil }

      it 'renders dashboard with logout button' do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
