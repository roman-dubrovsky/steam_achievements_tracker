class GamesController < ApplicationController
  def new
    @game = Games::AddForm.new(current_user)

    if @game.games_list.present?
      render :new
    else
      render :no_games, status: :not_found
    end
  end
end
