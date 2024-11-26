class GamesController < ApplicationController
  def new
    @game = Game.new
    @games = Steam::ApiClient.new(current_user).games
  end
end
