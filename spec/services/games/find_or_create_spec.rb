RSpec.describe Games::FindOrCreate do
  subject(:result) do
    described_class.call(user, form)
  end

  let(:user) { create(:user) }
  let(:form) { Games::AddForm.new(user) }
  let(:app_uid) { Faker::Crypto.md5 }

  let(:api_client) { instance_double(Steam::ApiClient, games: steam_games) }
  let(:store_client) { instance_double(Steam::StoreClient) }

  let(:steam_games) do
    [
      { "appid" => Faker::Crypto.md5 },
      { "appid" => app_uid },
      { "appid" => Faker::Crypto.md5 },
      { "appid" => Faker::Crypto.md5 }
    ]
  end

  let(:game_info) do
    {
      "name" => Faker::App.name,
      "header_image" => Faker::Internet.url
    }
  end

  before do
    form.assign_attributes(app_uid: app_uid)

    allow(Steam::ApiClient).to receive(:new)
      .with(user)
      .and_return(api_client)

    allow(Steam::StoreClient).to receive(:new)
      .and_return(store_client)

    allow(store_client).to receive(:game_info)
      .with(app_uid)
      .and_return(game_info)
  end

  context 'when the game has not been added to the system' do
    let(:created_game) { Game.last }

    it 'creates a new game' do
      expect { result }.to change { Game.count }.by(1)
    end

    it 'does not return failure result' do
      expect(result.failure).to be nil
    end

    it 'returns created game as a result' do
      expect(result.success).to eq(created_game)
    end

    it 'sets name for created game' do
      expect(result.success.name).to eq game_info["name"]
    end

    it 'sets image for created game' do
      expect(result.success.image).to eq game_info["header_image"]
    end

    it 'sets app uid for created game' do
      expect(result.success.app_uid).to eq app_uid
    end
  end

  context 'when the game present in the system' do
    let!(:game) { create(:game, app_uid: app_uid) }

    it 'does not create a new game' do
      expect { result }.not_to change { Game.count }
    end

    it 'does not return failure result' do
      expect(result.failure).to be nil
    end

    it 'returns the game as a result' do
      expect(result.success).to eq(game.reload)
    end

    it 'updates name for the game' do
      expect(result.success.name).to eq game_info["name"]
    end

    it 'updates image for the game' do
      expect(result.success.image).to eq game_info["header_image"]
    end

    context 'when could not get game info from store service' do
      let(:game_info) { nil }

      it 'does not create a new game' do
        expect { result }.not_to change { Game.count }
      end

      it 'does not return failure result' do
        expect(result.failure).to be nil
      end

      it 'returns the game as a result' do
        expect(result.success).to eq(game.reload)
      end

      it 'does not update name for the game' do
        expect(result.success.name).to eq game.name
      end

      it 'does not update image for the game' do
        expect(result.success.image).to eq game.image
      end
    end

    context 'when not all parameters passed via Store Steam API' do
      let(:game_info) do
        {
          "name" => Faker::App.name,
          "header_image" => nil
        }
      end

      it 'does not create a new game' do
        expect { result }.not_to change { Game.count }
      end

      it 'does not return failure result' do
        expect(result.failure).to be nil
      end

      it 'returns the game as a result' do
        expect(result.success).to eq(game.reload)
      end

      it 'does not update name for the game' do
        expect(result.success.name).to eq game.name
      end

      it 'does not update image for the game' do
        expect(result.success.image).to eq game.image
      end
    end
  end

  context 'when not all parameters passed via Store Steam API' do
    let(:game_info) do
      {
        "name" => Faker::App.name,
        "header_image" => nil
      }
    end

    it 'does not return success result' do
      expect(result.success).to be nil
    end

    it 'returns error message in the failure' do
      expect(result.failure).to eq("Couldn't get all data about game via Steam Store Service. Please, contact support for resolving your issue.")
    end
  end

  context 'when the geme has been already added for the user' do
    let(:game) { create(:game) }
    let(:app_uid) { game.app_uid }

    before { create(:game_user, game: game, user: user) }

    it 'does not return success result' do
      expect(result.success).to be nil
    end

    it 'returns error message in the failure' do
      expect(result.failure).to eq("Game is not included in the list or added before")
    end
  end

  context 'when form valudation error' do
    let(:app_uid) { "" }

    it 'does not return success result' do
      expect(result.success).to be nil
    end

    it 'returns error message in the failure' do
      expect(result.failure).to eq("Game can't be blank")
    end
  end

  context 'when the game is not found in the steam store service or other network issues' do
    let(:game_info) { nil }

    it 'does not return success result' do
      expect(result.success).to be nil
    end

    it 'returns error message in the failure' do
      expect(result.failure).to eq("Couldn't get connection with Steam Store service. Please, try to add the game later.")
    end
  end
end
