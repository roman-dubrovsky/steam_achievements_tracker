# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # , :trackable
  devise :rememberable

  validates :steam_uid, :nickname, :avatar_url, presence: true
  validates :steam_uid, uniqueness: true

  has_many :game_users, dependent: :destroy
  has_many :games, through: :game_users
end
