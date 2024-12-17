# frozen_string_literal: true

RSpec.describe Achievements::Create do
  subject(:created_achievement) { described_class.call(game, params) }

  let(:game) { create(:game) }

  let(:achievement) { [build(:achievement), build(:hidden_achievement)].sample }

  let(:params) { api_achievemt_params(achievement) }

  it "creates new achievement for the game" do
    expect { created_achievement }.to change { game.reload.achievements.count }.by(1)
  end

  %i[uid name description hidden icon icongray].each do |column|
    it "sets correct #{column}" do
      expect(created_achievement.public_send(column)).to eq achievement.public_send(column)
    end
  end
end
