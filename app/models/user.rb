class User < ApplicationRecord
  has_many :user_reviews, dependent: :destroy
  has_many :playing_games, dependent: :destroy
  has_many :games, through: :playing_games
  has_one :authentication, dependent: :destroy
  has_many :shop_histories

  accepts_nested_attributes_for :authentication

  mount_uploader :avatar, AvatarUploader

  authenticates_with_sorcery!

  VALID_PASSWORD_REGEX = /(?=.*?[a-z])(?=.*?[A-Z])[a-zA-Z\d!?_.$&%\-]{8,30}/
  validates :password, length: { in: 8..30 }, format: { with: VALID_PASSWORD_REGEX }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  VALID_EMAIL_REGEX = /[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}/
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, unless: :authentication
  validates :nickname, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 300 }
  validates :anonymous, inclusion: { in: [true, false] }

  enum role: { general: 0, admin: 1 }

  scope :admin, -> { where(role: :admin) }

  def create_playing_games(games_params)
    games_params&.each do |game_id, _value|
      game = Game.find(game_id)
      playing_game = playing_games.build(game:)
      playing_game.save!
    end
  end
end
