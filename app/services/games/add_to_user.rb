class Games::AddToUser
  include Callable

  attr_reader :game, :user

  def initialize(game, user)
    @game = game
    @user = user
  end

  def call
    user.game_users.create(game: game)
  end
end
