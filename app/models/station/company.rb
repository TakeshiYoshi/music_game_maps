class Station::Company < ApplicationRecord
  has_many :lines

  validates :name, presence: true
end
