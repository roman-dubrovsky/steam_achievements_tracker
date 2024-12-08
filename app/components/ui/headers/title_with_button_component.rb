# frozen_string_literal: true

class Ui::Headers::TitleWithButtonComponent < ViewComponent::Base
  attr_reader :title, :button_href, :button_title

  def initialize(title:, button_href:, button_title:)
    @title = title
    @button_href = button_href
    @button_title = button_title
  end
end
