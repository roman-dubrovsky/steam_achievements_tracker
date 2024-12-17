# frozen_string_literal: true

class Game < ApplicationRecord
  self.per_page = 5

  has_many :game_users, dependent: :destroy
  has_many :achievements, dependent: :destroy

  validates :app_uid, :name, :image, presence: true
  validates :app_uid, uniqueness: true
end
