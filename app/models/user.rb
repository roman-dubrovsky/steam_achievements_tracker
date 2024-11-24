class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :rememberable, :trackable

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
end
