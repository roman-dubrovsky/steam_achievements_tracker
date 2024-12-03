class Games::GetListForAdding
  include Callable

  def initialize(user)
    @user = user
  end

  def call
    steam_info.reject do |info|
      game_ids.include?(info["appid"])
    end
  end

  private

  attr_reader :user

  def game_ids
    @_game_ids ||= user.games.pluck(:app_uid)
  end

  def steam_info
    @_steam_info ||= Steam::ApiClient.new(user).games
      .map do |info|
        {
          "appid" => info["appid"],
          "name" => info["name"]
        }
      end
  end
end
