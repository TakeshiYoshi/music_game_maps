class Shop < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  has_many :user_reviews, dependent: :destroy
  has_many :game_machines, dependent: :destroy
  has_many :games, through: :game_machines

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :in_prefecture, ->(prefecture_id) { where(prefecture_id: prefecture_id) }
  scope :in_city, ->(city_id) { where(city_id: city_id) }
end
