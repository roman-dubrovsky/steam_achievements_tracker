class Games::ListPresenter
  delegate :present?, to: :relation

  # for will_paginate
  delegate :total_pages, :current_page, to: :relation

  def initialize(relation, user)
    @relation = relation
    @user = user
  end

  def info
    @_games ||= relation.map do |game|
      Games::CardPresenter.new(game: game, user: user)
    end
  end

  private

  attr_reader :relation, :user
end
