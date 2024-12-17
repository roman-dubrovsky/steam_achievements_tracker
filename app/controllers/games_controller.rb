# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    # TODO: fix query. Ignoring N + 1 for now.
    # I just need to get more info from other tables and going to fix it later.
    query = GameUsers::ListForUserQuery.call(current_user.game_users)
      .paginate(page: params[:page])

    @games = Games::ListPresenter.new(query)
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
      @game = Games::NewCardPresenter.new(game: result.success, user: current_user)
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
