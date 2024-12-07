# frozen_string_literal: true

class Games::SelectComponent < ViewComponent::Base
  attr_reader :form, :attribute, :games

  def initialize(form:, attribute:, games:)
    @form = form
    @attribute = attribute
    @games = games
  end
end
