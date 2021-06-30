class City < ApplicationRecord
  belongs_to :prefecture
  has_many :shops

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
