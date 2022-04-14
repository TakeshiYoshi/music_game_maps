class ShopFixRequest < ApplicationRecord
  belongs_to :shop

  validates :body, length: { maximum: 1000 }

  enum :status, { posted: 0, checked: 1 }
end
