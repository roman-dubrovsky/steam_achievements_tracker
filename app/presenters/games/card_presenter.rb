class Games::CardPresenter
  delegate :name, :image, :id, to: :game
  delegate :user, :game, to: :game_user

  def initialize(game_user:, achievements_count: nil, completed_achievements_count: nil)
    @game_user = game_user
    @achievements_count = achievements_count
    @completed_achievements_count = completed_achievements_count
  end

  def achievements_count
    @achievements_count || game_user.achievement_users.count
  end

  def completed_achievements_count
    @completed_achievements_count || game_user.achievement_users.completed.count
  end

  private

  attr_reader :game_user
end
