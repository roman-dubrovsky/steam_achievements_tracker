# frozen_string_literal: true

RSpec.describe Games::AddToUser do
  subject(:add_game) { described_class.call(game, user) }

  let(:user) { create(:user) }
  let(:game) { create(:game) }

  let(:count) { rand(3..5) }
  let(:achievements) do
    Array.new(count) do
      create(:achievement, game:)
    end
  end

  let(:achievements_steam_info) do
    achievements.map do |record|
      {
        "apiname" => record.uid,
        "achieved" => [0, 1].sample,
        "unlocktime" => Faker::Time.backward(days: rand(1..100)).to_i,
      }
    end
  end

  let(:api_client) { instance_double(Steam::ApiClient) }

  before do
    allow(Steam::ApiClient).to receive(:new)
      .with(user)
      .and_return(api_client)

    allow(api_client).to receive(:achievements)
      .with(game.app_uid)
      .and_return(achievements_steam_info)
  end

  context "when the game has some achievements" do
    let(:game_user) { GameUser.find_by(game:, user:) }

    it "adds new game for user" do
      expect { add_game }.to change { user.reload.games.count }.by(1)
    end

    it "adds exactly passed game for the user" do
      add_game
      expect(user.reload.games.last).to eq game
    end

    it "creates records for user achievements" do
      expect { add_game }.to change { AchievementUser.count }.by(count)
    end

    it "creates achievements exactly for needed game user" do
      add_game
      expect(game_user.achievement_users.count).to be count
    end

    context "when checking with a single completed achievement" do
      let(:achievement) { create(:achievement, game:) }
      let(:achievements) { [achievement] }
      let(:created_achievement) { game_user.achievement_users.first }

      let(:achievements_steam_info) do
        [{
          "apiname" => achievement.uid,
          "achieved" => 1,
          "unlocktime" => time.to_i,
        }]
      end

      let(:time) { Faker::Time.backward(days: rand(1..100)) }

      it "sets correct completed status" do
        add_game
        expect(created_achievement.completed).to be true
      end

      it "sets completed time" do
        add_game
        expect(created_achievement.completed_at).to eq time
      end
    end
  end

  context "when the game does not have achievements" do
    it "adds new game for user" do
      expect { add_game }.to change { user.reload.games.count }.by(1)
    end

    it "adds exactly passed game for the user" do
      add_game
      expect(user.reload.games.last).to eq game
    end

    it "does not create records for user achievements" do
      expect { add_game }.to change { AchievementUser.count }.by(count)
    end
  end
end
