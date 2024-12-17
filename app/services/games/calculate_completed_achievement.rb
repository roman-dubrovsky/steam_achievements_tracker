# frozen_string_literal: true

class Games::CalculateCompletedAchievement
  include Callable

  attr_reader :user, :game

  def initialize(user, game)
    @user = user
    @game = game
  end

  def call
    achievements_info.present? ? achievements_info.count { |data| data["achieved"] == 1 } : 0
  end

  private

  def achievements_info
    @_achievements_info ||= api_client.achievements(game.app_uid)
  end

  def api_client
    @_api_client ||= Steam::ApiClient.new(user)
  end
end
