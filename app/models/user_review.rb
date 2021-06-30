class UserReview < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  validates :body, presence: true, length: { maximum: 1000 }
end
