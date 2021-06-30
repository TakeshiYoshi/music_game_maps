class Shop < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  has_many :user_reviews
  has_many :games, through: :game_machines
  has_many :game_machines

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
