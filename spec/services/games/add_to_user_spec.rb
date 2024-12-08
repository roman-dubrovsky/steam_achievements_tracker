RSpec.describe Games::AddToUser do
  subject(:add_game) { described_class.call(game, user) }

  let(:user) { create(:user) }
  let(:game) { create(:game) }

  it 'adds new game for user' do
    expect { add_game }.to change { user.reload.games.count }.by(1)
  end

  it 'adds exactly passed game for the user' do
    add_game
    expect(user.reload.games.last).to eq game
  end
end
