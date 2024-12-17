# frozen_string_literal: true

class GameUsers::ListForUserQuery
  include Callable

  attr_reader :relation

  def initialize(relation)
    @relation = relation
  end

  def call
    relation_with_counts
      .includes(:game)
      .order(created_at: :desc)
  end

  private

  def relation_with_counts
    relation.with(achievements_counts: achievements_counts_cte)
      .left_joins(:achievements_counts)
      .select(data_attributes_with_counts)
  end

  def data_attributes_with_counts
    [
      "game_users.*",
      "COALESCE(achievements_counts.count, 0) AS achievements_count",
      "COALESCE(achievements_counts.completed_count, 0) AS completed_achievements_count",
    ].join(", ")
  end

  def achievements_counts_cte
    relation.joins(:achievement_users)
      .select(achievements_counts_cte_select_fields)
      .group("game_users.id")
  end

  def achievements_counts_cte_select_fields
    [
      "game_users.id as game_user_id",
      "COUNT(game_users.id) as count",
      "COUNT(CASE WHEN achievement_users.completed = TRUE THEN 1 END) AS completed_count",
    ].join(", ")
  end
end
