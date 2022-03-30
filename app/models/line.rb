class Line < ApplicationRecord
  belongs_to :company
  has_many :stations, dependent: :destroy

  validates :name, presence: true
end
