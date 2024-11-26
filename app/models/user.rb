class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # , :trackable
  devise :rememberable

  validates_presence_of :steam_uid, :nickname, :avatar_url
  validates_uniqueness_of :steam_uid
end
