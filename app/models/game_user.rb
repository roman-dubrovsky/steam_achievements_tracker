class GameUser < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :achievement_users, dependent: :destroy

  validates_uniqueness_of :game, scope: :user_id
end
