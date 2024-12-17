# frozen_string_literal: true

class Games::AddForm
  include ActiveModel::Model

  attr_accessor :app_uid

  validates :app_uid, presence: true, inclusion: {in: ->(form) { form.game_ids }}

  def initialize(user)
    @user = user
  end

  def games_list
    @_games_list ||= Games::GetListForAdding.call(user)
  end

  def game_ids
    games_list.pluck("appid")
  end

  private

  attr_reader :user
end
