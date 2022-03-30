class Station < ApplicationRecord
  belongs_to :line
  belongs_to :prefecture

  validates :name, presence: true
end
