RSpec.describe Steam::StoreClient do
  describe '#game_info' do
    subject(:client) { described_class.new }

    let(:game_id) { 289070 } # Example game ID for Civilization VI
    let(:url) { "https://store.steampowered.com/api/appdetails?appids=#{game_id}" }

    context 'when the game exists' do
      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            body: {
              "#{game_id}" => {
                "success" => true,
                "data" => {
                  "name" => "Sid Meier's Civilization VI",
                  "capsule_image" => "https://cdn.akamai.steamstatic.com/steam/apps/289070/capsule_616x353.jpg"
                }
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns the game name and capsule image' do
        result = client.game_info(game_id)
        expect(result["name"]).to eq("Sid Meier's Civilization VI")
        expect(result["capsule_image"]).to eq("https://cdn.akamai.steamstatic.com/steam/apps/289070/capsule_616x353.jpg")
      end
    end

    context 'when the game is not found' do
      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            body: {
              "#{game_id}" => {
                "success" => false
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns nil' do
        result = client.game_info(game_id)
        expect(result).to be_nil
      end
    end

    context 'when the API returns an invalid JSON' do
      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            body: "invalid json"
          )
      end

      it 'returns nil' do
        result = client.game_info(game_id)
        expect(result).to be_nil
      end
    end
  end
end
