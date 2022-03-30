class Station::Line < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
end
