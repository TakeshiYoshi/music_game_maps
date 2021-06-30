class Game < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
