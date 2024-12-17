# frozen_string_literal: true

class Achievement < ApplicationRecord
  belongs_to :game

  has_many :achievement_users, dependent: :destroy

  validates :uid, :name, :icon, :icongray, presence: true
  validates :uid, uniqueness: {scope: :game_id}
end
