# frozen_string_literal: true

class Game::Card::AchievementsInfoComponent < ViewComponent::Base
  attr_reader :completed_count, :count

  def initialize(completed_count:, count:)
    @completed_count = completed_count
    @count = count
  end

  def percent
    (completed_count.to_f / count * 100).to_i
  end

  def render?
    count.positive?
  end
end
