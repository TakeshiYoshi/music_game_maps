class Game < ApplicationRecord
  has_many :shops, through: :game_machines
  has_many :game_machines
  has_many :users, through: :playing_games
  has_many :playing_games

  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
