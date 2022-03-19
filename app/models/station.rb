class Station < ApplicationRecord
  belongs_to :line
  belongs_to :prefecture
  has_many :shop_stations, dependent: :destroy
  has_many :shops, through: :shop_stations

  validates :name, presence: true
end
