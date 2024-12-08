class GamesController < ApplicationController
  def index
    @games = current_user.games
      .paginate(page: params[:page])
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
      @game = result.success
      render :accept, status: :created
    else
      @error_message = result.failure
      render :new, status: :bad_request
    end
  end

  def accept
    Games::AddToUser.call(game, current_user)
    redirect_to games_path
  end

  private

  def game
    @_game ||= Game.find(params[:id])
  end

  def game_params
    params.require(:games_add_form).permit(:app_uid)
  end
end
