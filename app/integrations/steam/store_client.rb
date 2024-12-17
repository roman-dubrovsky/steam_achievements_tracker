# frozen_string_literal: true

class Steam::StoreClient < Steam::BaseClient
  API_URL = "https://store.steampowered.com/api"

  GAME_INFO_PATH = "appdetails"

  def game_info(game_id)
    get(GAME_INFO_PATH, {appids: [game_id]})&.dig(game_id.to_s, "data")
  end
end
