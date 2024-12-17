# frozen_string_literal: true

class Steam::ApiClient < Steam::BaseClient
  API_URL = "https://api.steampowered.com"

  GAMES_LIST_PATH = "IPlayerService/GetOwnedGames/v1/"
  ACHIEVEMENTS_PATH = "ISteamUserStats/GetPlayerAchievements/v1/"
  GAME_INFO_PATH = "ISteamUserStats/GetSchemaForGame/v2/"

  def initialize(user)
    super()
    @user = user
  end

  def games
    get(GAMES_LIST_PATH, {include_appinfo: 1, steamid: user_steam_uid})&.dig("response", "games")
  end

  # for test 214730 (XCOM2), 289070 (CIV6), 394360 (HOI4)
  def achievements(game_id)
    get(ACHIEVEMENTS_PATH, {appid: game_id, steamid: user_steam_uid})&.dig("playerstats", "achievements")
  end

  def achievements_info(game_id)
    get(GAME_INFO_PATH, {appid: game_id})&.dig("game", "availableGameStats", "achievements")
  end

  private

  attr_reader :user

  delegate :steam_uid, to: :user, prefix: true

  def api_key
    Rails.application.credentials[:steam_api_key]
  end

  def get(path, params = {})
    super(path, params.merge({
      key: api_key,
    }))
  end
end
