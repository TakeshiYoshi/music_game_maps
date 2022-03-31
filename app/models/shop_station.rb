class ShopStation < ApplicationRecord
  belongs_to :shop
  belongs_to :station

  validates :shop_id, uniqueness: { scope: :station_id }
end
