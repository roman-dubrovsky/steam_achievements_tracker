class Games::AddToUser
  include Callable

  attr_reader :game, :user

  def initialize(game, user)
    @game = game
    @user = user
  end

  def call
    game_user = user.game_users.create(game: game)

    game.achievements.each do |achievement|
      steam_achievement = steam_achievements.find { |info| info["apiname"].to_s == achievement.uid }
      completed = steam_achievement["achieved"] == 1

      achievement.achievement_users.create(
        game_user: game_user,
        completed: completed,
        completed_at: completed ? Time.at(steam_achievement["unlocktime"]) : nil,
      )
    end
  end

  private

  def steam_achievements
    @_steam_achievements ||= api_steam_client.achievements(game.app_uid)
  end

  def api_steam_client
    @_api_store_client ||= Steam::ApiClient.new(user)
  end
end
