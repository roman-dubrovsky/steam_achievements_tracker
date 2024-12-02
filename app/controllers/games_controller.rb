class GamesController < ApplicationController
  def new
    @game = Games::AddForm.new(current_user)
  end
end
