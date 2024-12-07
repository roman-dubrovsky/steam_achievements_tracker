# frozen_string_literal: true

class Forms::ErrorNotificationComponent < ViewComponent::Base
  attr_reader :message

  def initialize(message:)
    @message = message
  end

  def render?
    message.present?
  end
end
