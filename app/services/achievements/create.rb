# frozen_string_literal: true

class Achievements::Create
  include Callable

  attr_reader :params, :game

  def initialize(game, params)
    @game = game
    @params = params
  end

  def call
    game.achievements.create(
      uid: params["name"],
      name: params["displayName"],
      description: params["description"],
      icon: params["icon"],
      icongray: params["icongray"],
      hidden: params["hidden"] == 1,
    )
  end
end
