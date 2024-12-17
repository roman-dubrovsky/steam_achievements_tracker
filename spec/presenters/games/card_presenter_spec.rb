# frozen_string_literal: true

RSpec.describe Games::CardPresenter do
  context "when gets data from single entity" do
    subject(:presenter) do
      described_class.new(game_user:)
    end

    let(:game_user) { create(:game_user, game:, user:) }

    before do
      achievements_count.times do
        achievement = create(:achievement, game:)
        create(:achievement_user, game_user:, achievement:)
      end

      AchievementUser.all.sample.update(completed: true)
    end

    include_examples "Games::CardPresenter logic" do
      let(:game) { create(:game) }
      let(:completed_achievements_count) { game_user.achievement_users.completed.count }
    end
  end

  context "when gets data from a list query" do
    subject(:presenter) do
      described_class.new(
        game_user: build(:game_user, game:, user:),
        completed_achievements_count:,
        achievements_count:,
      )
    end

    include_examples "Games::CardPresenter logic"
  end
end
