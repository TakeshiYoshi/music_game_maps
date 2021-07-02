class UserReview < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :about_games
  has_many :games, through: :about_games

  validates :body, presence: true, length: { maximum: 1000 }
end
