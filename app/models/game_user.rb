# frozen_string_literal: true

class GameUser < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :achievement_users, dependent: :destroy

  validates :game, uniqueness: {scope: :user_id}
end
