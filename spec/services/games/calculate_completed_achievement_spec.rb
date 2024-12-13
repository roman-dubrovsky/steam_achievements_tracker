RSpec.describe Games::CalculateCompletedAchievement do
  subject do
    described_class.call(user, game)
  end

  let(:user) { build(:user) }
  let(:game) { build(:game) }

  let(:api_client) { instance_double(Steam::ApiClient) }

  before do
    allow(Steam::ApiClient).to receive(:new)
      .with(user)
      .and_return(api_client)

    allow(api_client).to receive(:achievements)
      .with(game.app_uid)
      .and_return(achievements_info)
  end

  context 'when game has achievements' do
    let(:uncompleted_count) { rand(1..100) }
    let(:completed_count) { rand(1..100) }

    let(:uncompleted_achievements) do
      Array.new(uncompleted_count) {
        { "achieved" => 0 }
      }
    end

    let(:completed_achievements) do
      Array.new(completed_count) {
        { "achieved" => 1 }
      }
    end

    let(:achievements_info) { (completed_achievements + uncompleted_achievements).shuffle }

    it { is_expected.to be completed_count }
  end

  context 'when game does not have achievements' do
    let(:achievements_info) { [] }

    it { is_expected.to be 0 }
  end

  context 'when steam API does not return achievements info (for old games)' do
    let(:achievements_info) { nil }

    it { is_expected.to be 0 }
  end
end
