class ShopHistory < ApplicationRecord
  belongs_to :user
  belongs_to :shop
end
