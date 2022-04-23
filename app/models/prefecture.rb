class Prefecture < ApplicationRecord
  has_many :cities
  has_many :shops
  has_many :stations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
