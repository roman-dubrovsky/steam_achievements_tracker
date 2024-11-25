RSpec.describe Steam::ApiClient do
  subject(:steam_client) { described_class.new(user) }

  let(:user) { build(:user) }
  let(:api_key) { "test_api_key" }

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:steam_api_key).and_return(api_key)
  end

  describe "#games" do
    let(:api_url) { "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/" }

    context "when the API returns a successful response" do
      let(:response_body) do
        {
          "response" => {
            "games" => [
              { "appid" => 1, "name" => "Game 1" },
              { "appid" => 2, "name" => "Game 2" }
            ]
          }
        }.to_json
      end

      before do
        stub_request(:get, api_url)
          .with(query: { key: api_key, steamid: user.steam_uid, include_appinfo: 1 })
          .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })
      end

      it "returns the list of games" do
        expect(steam_client.games).to eq([
          { "appid" => 1, "name" => "Game 1" },
          { "appid" => 2, "name" => "Game 2" }
        ])
      end
    end

    context "when the API returns an error response" do
      before do
        stub_request(:get, api_url)
          .with(query: { key: api_key, steamid: user.steam_uid, include_appinfo: 1 })
          .to_return(status: 500, body: "Internal Server Error")
      end

      it "returns nil" do
        expect(steam_client.games).to be_nil
      end
    end

    context "when the API returns an invalid JSON" do
      before do
        stub_request(:get, api_url)
          .with(query: { key: api_key, steamid: user.steam_uid, include_appinfo: 1 })
          .to_return(status: 200, body: "invalid json")
      end

      it "raises a JSON::ParserError" do
        expect(steam_client.games).to be_nil
      end
    end
  end

  describe '#achievements' do
    let(:game_id) { 289070 }
    let(:api_url) { "https://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v1/?appid=#{game_id}&steamid=#{user.steam_uid}&key=#{api_key}" }

    context 'when the achievements exist' do
      before do
        stub_request(:get, api_url)
          .to_return(
            status: 200,
            body: {
              "playerstats" => {
                "achievements" => [
                  { "apiname" => "ACH_WIN_ONE_GAME", "achieved" => 1 },
                  { "apiname" => "ACH_WIN_100_GAMES", "achieved" => 0 }
                ]
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns the achievements with apiname and achieved fields' do
        result = steam_client.achievements(game_id)
        expect(result).to be_an(Array)
        expect(result.first["apiname"]).to eq("ACH_WIN_ONE_GAME")
        expect(result.first["achieved"]).to eq(1)
      end
    end

    context 'when there are no achievements' do
      before do
        stub_request(:get, api_url)
          .to_return(
            status: 200,
            body: {
              "playerstats" => {
                "achievements" => []
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns an empty array' do
        result = steam_client.achievements(game_id)
        expect(result).to eq([])
      end
    end

    context "when the API returns an invalid JSON" do
      before do
        stub_request(:get, api_url)
          .to_return(status: 200, body: "invalid json")
      end

      it "raises a JSON::ParserError" do
        expect(steam_client.achievements(game_id)).to be_nil
      end
    end
  end

  describe '#achievements_info' do
    let(:game_id) { 289070 }
    let(:api_url) { "https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?appid=#{game_id}&key=#{api_key}" }

    context 'when the achievements info is available' do
      before do
        stub_request(:get, api_url)
          .to_return(
            status: 200,
            body: {
              "game" => {
                "availableGameStats" => {
                  "achievements" => [
                    {
                      "name" => "ACH_WIN_ONE_GAME",
                      "displayName" => "Win One Game",
                      "description" => "Win your first game",
                      "icon" => "https://cdn.akamai.steamstatic.com/icons/ach_win_one_game.png",
                      "icongray" => "https://cdn.akamai.steamstatic.com/icons/ach_win_one_game_gray.png"
                    }
                  ]
                }
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns the achievements info with required fields' do
        result = steam_client.achievements_info(game_id)
        expect(result).to be_an(Array)
        expect(result.first["name"]).to eq("ACH_WIN_ONE_GAME")
        expect(result.first["displayName"]).to eq("Win One Game")
        expect(result.first["description"]).to eq("Win your first game")
        expect(result.first["icon"]).to eq("https://cdn.akamai.steamstatic.com/icons/ach_win_one_game.png")
        expect(result.first["icongray"]).to eq("https://cdn.akamai.steamstatic.com/icons/ach_win_one_game_gray.png")
      end
    end

    context 'when the achievements info is missing' do
      before do
        stub_request(:get, api_url)
          .to_return(
            status: 200,
            body: {
              "game" => {
                "availableGameStats" => {
                  "achievements" => []
                }
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns an empty array' do
        result = steam_client.achievements_info(game_id)
        expect(result).to eq([])
      end
    end

    context "when the API returns an invalid JSON" do
      before do
        stub_request(:get, api_url)
          .to_return(status: 200, body: "invalid json")
      end

      it "raises a JSON::ParserError" do
        expect(steam_client.achievements_info(game_id)).to be_nil
      end
    end
  end
end
