class UserReview < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :about_games, dependent: :destroy
  has_many :games, through: :about_games

  mount_uploaders :images, UserReviewUploader

  validates :body, presence: true, length: { maximum: 1000 }

  MAX_IMAGE_COUNT = 4
end
