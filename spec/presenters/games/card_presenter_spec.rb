RSpec.describe Games::CardPresenter do
  subject(:presenter) do
    described_class.new(user: user, game: game)
  end

  let(:game_user) { create(:game_user, game: game, user: user) }

  before do
    achievements_count.times do
      achievement = create(:achievement, game: game)
      create(:achievement_user, game_user: game_user)
    end

    AchievementUser.all.sample.update(completed: true)
  end

  include_examples "Games::CardPresenter logic" do
    let(:game) { create(:game) }
    let(:completed_achievements_count) { 1 }
  end
end
