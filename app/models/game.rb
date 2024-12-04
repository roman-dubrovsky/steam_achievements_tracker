class Game < ApplicationRecord
  validates_presence_of :app_uid, :name, :image
  validates_uniqueness_of :app_uid
end
