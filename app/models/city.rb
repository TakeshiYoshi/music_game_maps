class City < ApplicationRecord
  belongs_to :prefecture
  has_many :shops

  validates :name, presence: true
end
