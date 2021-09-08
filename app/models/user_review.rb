class UserReview < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :about_games, dependent: :destroy
  has_many :games, through: :about_games

  mount_uploaders :images, UserReviewUploader

  validates :body, presence: true, length: { maximum: 1000 }

  def create_about_games(games_params)
    games_params&.each do |game_id, _value|
      game = Game.find(game_id)
      about_game = about_games.build(game: game)
      about_game.save!
    end
  end
end
