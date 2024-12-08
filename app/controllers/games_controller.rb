class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game_form = Games::AddForm.new(current_user)

    if @game_form.games_list.present?
      render :new
    else
      render :no_games, status: :not_found
    end
  end

  def create
    @game_form = Games::AddForm.new(current_user)
    @game_form.assign_attributes(game_params)

    result = Games::FindOrCreate.call(current_user, @game_form)

    if result.success
      render plain: result.success.name, status: :created
    else
      @error_message = result.failure
      render :new, status: :bad_request
    end
  end

  private

  def game_params
    params.require(:games_add_form).permit(:app_uid)
  end
end
