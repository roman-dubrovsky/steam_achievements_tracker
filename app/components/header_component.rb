# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  attr_reader :current_user

  def initialize(current_user:)
    @current_user = current_user
  end

  def signed_in?
    current_user.present?
  end

  delegate :avatar_url, :nickname, to: :current_user
end
