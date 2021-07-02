class User < ApplicationRecord
  has_many :user_reviews
  has_many :playing_games
  has_many :games, through: :playing_games

  authenticates_with_sorcery!

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :nickname, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 300 }
  validates :anonymous, inclusion: { in: [true, false] }
end
