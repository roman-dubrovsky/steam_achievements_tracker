# frozen_string_literal: true

RSpec.shared_examples "Games::CardPresenter logic" do
  let(:user) { build(:user) }
  let(:game) { build(:game) }

  let(:achievements_count) { rand(2..5) }
  let(:completed_achievements_count) { rand(2..5) }

  describe "#name" do
    its(:name) { is_expected.to eq game.name }
  end

  describe "#image" do
    its(:image) { is_expected.to eq game.image }
  end

  describe "#achievements_count" do
    its(:achievements_count) { is_expected.to eq achievements_count }
  end

  describe "#completed_achievements_count" do
    its(:completed_achievements_count) { is_expected.to eq completed_achievements_count }
  end
end
