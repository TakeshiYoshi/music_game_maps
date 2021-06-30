class Game < ApplicationRecord
  has_many :shops, through: :game_machines
  has_many :game_machines

  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
