class Achievement < ApplicationRecord
  belongs_to :game

  has_many :achievement_users, dependent: :destroy

  validates_presence_of :uid, :name, :icon, :icongray
  validates_uniqueness_of :uid, scope: :game_id
end
