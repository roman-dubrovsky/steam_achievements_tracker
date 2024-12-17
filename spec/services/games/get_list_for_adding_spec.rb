# frozen_string_literal: true

RSpec.describe Games::GetListForAdding do
  subject(:get_list) do
    described_class.call(user)
  end

  let(:steam_games) do
    [
      {"appid" => "id1", "name" => "Game 1"},
      {"appid" => "id2", "name" => "Game 2"},
    ]
  end

  let(:user) { create(:user) }

  let(:api_client) { instance_double(Steam::ApiClient, games: steam_games) }

  before do
    allow(Steam::ApiClient).to receive(:new)
      .with(user)
      .and_return(api_client)
  end

  context "when the user does not have added games" do
    it "return all games from steam" do
      is_expected.to contain_exactly({"appid" => "id1", "name" => "Game 1"}, {"appid" => "id2", "name" => "Game 2"})
    end
  end

  context "when the user added some game before" do
    let(:game) { create(:game, app_uid: "id1") }

    before { create(:game_user, user:, game:) }

    it "return filtered games from steam" do
      is_expected.to contain_exactly({"appid" => "id2", "name" => "Game 2"})
    end
  end
end
