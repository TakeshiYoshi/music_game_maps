class Prefecture < ApplicationRecord
  has_many :cities
  has_many :shops

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
