class Games::CardPresenter
  delegate :name, :image, to: :game

  def initialize(user:, game:)
    @user = user
    @game = game
  end

  def achievements_count
    game.achievements.count
  end

  def completed_achievements_count
    0
  end

  private

  attr_reader :game, :user
end
