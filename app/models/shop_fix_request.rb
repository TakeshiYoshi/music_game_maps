class ShopFixRequest < ApplicationRecord
  belongs_to :shop

  validates :not_exist, presence: true
  validates :duplicate, presence: true
  validates :fix_shop_info, presence: true
  validates :body, length: { maximum: 1000 }

  enum :status, { posted: 0, checked: 1 }
end
