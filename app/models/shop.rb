class Shop < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  has_many :user_reviews, dependent: :destroy
  has_many :game_machines, dependent: :destroy
  has_many :games, through: :game_machines

  mount_uploader :appearance_image, ShopAppearanceImageUploader

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   lat_column_name: :lat,
                   lng_column_name: :lng

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :in_prefecture, ->(prefecture_id) { where(prefecture_id: prefecture_id) }
  scope :in_city, ->(city_id) { where(city_id: city_id) }

  def create_game_machines(game_machines_params)
    game_machines_params&.each do |game_id, count|
      next if count.to_i.zero?

      game = Game.find(game_id)
      game_machine = game_machines.build(game: game, count: count)
      game_machine.save!
    end
  end
end
