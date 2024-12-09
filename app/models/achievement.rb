class Achievement < ApplicationRecord
  belongs_to :game

  validates_presence_of :uid, :name, :icon, :icongray
  validates_uniqueness_of :uid, scope: :game_id
end
