class Users::FindViaSteam
  include Callable

  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    current_user.nickname = auth.dig("info", "nickname")
    current_user.avatar_url = auth.dig("info", "image")
    current_user.save! if current_user.changed?
    current_user
  end

  private

  def current_user
    @_current_user ||= User.find_or_initialize_by(steam_uid: auth["uid"])
  end
end
