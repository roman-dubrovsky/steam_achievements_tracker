# frozen_string_literal: true

RSpec.describe Games::NewCardPresenter do
  subject(:presenter) do
    described_class.new(user:, game:)
  end

  before do
    achievements_count.times do
      create(:achievement, game:)
    end

    allow(Games::CalculateCompletedAchievement).to receive(:call)
      .with(user, game)
      .and_return(completed_achievements_count)
  end

  include_examples "Games::CardPresenter logic" do
    let(:game) { create(:game) }
  end
end
