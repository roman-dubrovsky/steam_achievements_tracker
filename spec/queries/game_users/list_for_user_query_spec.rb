# frozen_string_literal: true

RSpec.describe GameUsers::ListForUserQuery do
  subject(:query) do
    described_class.call(relation)
  end

  let(:relation) { GameUser.all }

  let(:game_user) { create(:game_user) }
  let(:current_game_user) { query.find_by(id: game_user.id) }

  let(:some_game_users) { create_list(:game_user, 3) }
  let(:user_game_users) { create_list(:game_user, 3, user: game_user.user) }
  let(:game_game_users) { create_list(:game_user, 3, game: game_user.game) }

  let(:other_game_users) { some_game_users + user_game_users + game_game_users }

  before do
    game_game_users

    rand(5..10).times do
      game_user = (some_game_users + user_game_users).sample

      achievement = create(:achievement, game: game_user.game)
      create(:achievement_user, achievement:, game_user:)
    end
  end

  it "returns all game_user from relation (no filtering)" do
    expect(query.pluck(:id)).to match_array([game_user.id] + other_game_users.map(&:id))
  end

  context "when game has completed achievements" do
    let(:achievements_count) { rand(5..10) }
    let(:completed_achivements) { rand(1..3) }

    before do
      achievements_count.times do
        achievement = create(:achievement, game: game_user.game)
        create(:achievement_user, achievement:, game_user:, completed: false)
      end

      completed_achivements.times do
        achievement = create(:achievement, game: game_user.game)
        create(:achievement_user, achievement:, game_user:, completed: true)
      end
    end

    it "returns game users list" do
      expect(query.pluck(:id)).to include(game_user.id)
    end

    it "has tested object in the result relation" do
      expect(current_game_user).not_to be_nil
    end

    it "calculates number of achivements for the game" do
      expect(current_game_user.achievements_count).to be(achievements_count + completed_achivements)
    end

    it "calculates number of completed achivements for the game" do
      expect(current_game_user.completed_achievements_count).to be(completed_achivements)
    end
  end

  context "when game does not have achivements" do
    it "returns game users list" do
      expect(query.pluck(:id)).to include(game_user.id)
    end

    it "has tested object in the result relation" do
      expect(current_game_user).not_to be_nil
    end

    it "calculates number of achivements for the game" do
      expect(current_game_user.achievements_count).to be 0
    end

    it "calculates number of completed achivements for the game" do
      expect(current_game_user.completed_achievements_count).to be 0
    end
  end
end
