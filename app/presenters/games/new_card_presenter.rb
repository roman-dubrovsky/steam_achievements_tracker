class Games::NewCardPresenter < Games::CardPresenter
  def completed_achievements_count
    @_completed_achievements_count ||= Games::CalculateCompletedAchievement.call(user, game)
  end
end
