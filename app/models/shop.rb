class Shop < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  has_many :user_reviews

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
