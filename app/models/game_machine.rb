class GameMachine < ApplicationRecord
  belongs_to :shop
  belongs_to :game

  validates :count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99 }
  validates :shop_id, uniqueness: { scope: :game_id }
end
