class Game < ApplicationRecord
  has_many :game_machines
  has_many :shops, through: :game_machines
  has_many :playing_games
  has_many :users, through: :playing_games
  has_many :about_games
  has_many :user_reviews, through: :about_games

  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
