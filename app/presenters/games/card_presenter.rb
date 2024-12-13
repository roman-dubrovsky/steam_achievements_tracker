class Games::CardPresenter
  delegate :name, :image, :id, to: :game

  def initialize(user:, game:)
    @user = user
    @game = game
  end

  def achievements_count
    game.achievements.count
  end

  def completed_achievements_count
    game.game_users.find_by(user: user).achievement_users.completed.count
  end

  private

  attr_reader :game, :user
end
