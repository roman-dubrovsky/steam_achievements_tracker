class Games::ListPresenter
  delegate :present?, to: :relation

  # for will_paginate
  delegate :total_pages, :current_page, to: :relation

  def initialize(relation)
    @relation = relation
  end

  def info
    @_games ||= relation.map do |game_user|
      Games::CardPresenter.new(
        game_user: game_user,
        achievements_count: game_user.achievements_count,
        completed_achievements_count: game_user.completed_achievements_count,
      )
    end
  end

  private

  attr_reader :relation, :user
end
