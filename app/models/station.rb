class Station < ApplicationRecord
  belongs_to :line
  belongs_to :prefecture

  has_many :shop_stations, dependent: :destroy
  has_many :shops, through: :shop_stations

  validates :name, presence: true

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   lat_column_name: :lat,
                   lng_column_name: :lng
end
