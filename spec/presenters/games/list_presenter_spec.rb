# frozen_string_literal: true

require "will_paginate/array"

RSpec.describe Games::ListPresenter do
  subject(:presenter) do
    described_class.new(relation)
  end

  let(:user) { instance_double(User) }

  let(:relation) { list.paginate(page: 1) }

  let(:total_pages) { rand(3..5) }
  let(:current_page) { rand(1..2) }

  before do
    allow(relation).to receive_messages(total_pages:, current_page:)
  end

  context "when relation is empty" do
    let(:list) { [] }

    its(:present?) { is_expected.to be false }
    its(:total_pages) { is_expected.to be total_pages }
    its(:current_page) { is_expected.to be current_page }
    its(:info) { is_expected.to eq([]) }
  end

  context "when relation has some items" do
    let(:count) { rand(1..10) }

    let(:list) do
      Array.new(count) do
        double(GameUser,
          game: instance_double(Game), user:,
          achievements_count: 100,
          completed_achievements_count: 0)
      end
    end

    its(:present?) { is_expected.to be true }
    its(:total_pages) { is_expected.to be total_pages }
    its(:current_page) { is_expected.to be current_page }
    its(:info) { is_expected.to all(be_an_instance_of(Games::CardPresenter)) }

    it "returns correct number of games" do
      expect(presenter.info.size).to eq count
    end
  end
end
