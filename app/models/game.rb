class Game < ApplicationRecord
  self.per_page = 5

  has_many :game_users, dependent: :destroy
  has_many :achievements, dependent: :destroy

  validates_presence_of :app_uid, :name, :image
  validates_uniqueness_of :app_uid
end
