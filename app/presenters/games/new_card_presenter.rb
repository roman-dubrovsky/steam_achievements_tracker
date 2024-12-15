class Games::NewCardPresenter < Games::CardPresenter
  attr_reader :game, :user

  def initialize(game:, user:)
    @game = game
    @user = user
  end

  def completed_achievements_count
    @_completed_achievements_count ||= Games::CalculateCompletedAchievement.call(user, game)
  end

  def achievements_count
    game.achievements.count
  end
end
