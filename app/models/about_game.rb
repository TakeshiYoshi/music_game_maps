class AboutGame < ApplicationRecord
  belongs_to :user_review
  belongs_to :game

  validates :user_review_id, uniqueness: { scope: :game_id }
end
