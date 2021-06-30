class City < ApplicationRecord
  belongs_to :prefecture

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
