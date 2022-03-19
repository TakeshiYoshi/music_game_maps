class Line < ApplicationRecord
  has_many :stations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
