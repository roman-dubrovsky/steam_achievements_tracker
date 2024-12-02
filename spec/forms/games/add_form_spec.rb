RSpec.describe Games::AddForm do
  subject(:form) { described_class.new(user) }

  let(:user) { build(:user) }

  let(:games) do
    [
      { "appid" => "id1", "name" => "Game 1" },
      { "appid" => "id2", "name" => "Game 2" }
    ]
  end

  before do
    allow(Games::GetListForAdding).to receive(:call)
      .with(user)
      .and_return(games)
  end

  describe "#games_list" do
    its(:games_list) do
      is_expected.to eq games
    end
  end

  describe "#game_ids" do
    its(:game_ids) do
      is_expected.to match_array([ "id1", "id2" ])
    end
  end

  describe "#valid?" do
    let(:app_uid) { "id1" }

    before do
      form.assign_attributes(app_uid: app_uid)
    end

    its(:valid?) { is_expected.to be true }

    context 'when app_uid is not present' do
      let(:app_uid) { "" }

      its(:valid?) { is_expected.to be false }
    end

    context 'when app_uid is not from games list' do
      let(:app_uid) { "some another id" }

      its(:valid?) { is_expected.to be false }
    end
  end
end
