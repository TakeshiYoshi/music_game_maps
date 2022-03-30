class Station::Company < ApplicationRecord
  validates :name, presence: true
end
