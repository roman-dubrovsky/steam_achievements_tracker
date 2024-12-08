# frozen_string_literal: true

class Game::CardComponent < ViewComponent::Base
  with_collection_parameter :game

  attr_reader :game
  delegate :name, :image, to: :game

  def initialize(game:)
    @game = game
  end
end
