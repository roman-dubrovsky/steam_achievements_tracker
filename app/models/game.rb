class Game < ApplicationRecord
  validates_presence_of :app_uid
  validates_uniqueness_of :app_uid
end
