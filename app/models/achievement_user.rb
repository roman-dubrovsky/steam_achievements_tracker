# frozen_string_literal: true

class AchievementUser < ApplicationRecord
  belongs_to :achievement
  belongs_to :game_user

  scope :completed, -> { where(completed: true) }
end
