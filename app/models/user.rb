# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  has_many :tasks, dependent: :destroy

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'is not a valid email address' }
  validates :password, presence: true
  validates :name, presence: true
end
