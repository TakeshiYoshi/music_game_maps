class Shop < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
