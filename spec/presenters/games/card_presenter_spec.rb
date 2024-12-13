RSpec.describe Games::CardPresenter do
  subject(:presenter) do
    described_class.new(user: user, game: game)
  end

  before do
    achievements_count.times do
      create(:achievement, game: game)
    end
  end

  include_examples "Games::CardPresenter logic" do
    let(:game) { create(:game) }
    let(:completed_achievements_count) { 0 }
  end
end
