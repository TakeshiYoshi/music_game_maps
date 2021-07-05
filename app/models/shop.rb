class Shop < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  has_many :user_reviews, dependent: :destroy
  has_many :game_machines, dependent: :destroy
  has_many :games, through: :game_machines

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
