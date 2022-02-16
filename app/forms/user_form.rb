class UserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :nickname

  VALID_PASSWORD_REGEX = /(?=.*?[a-z])(?=.*?[A-Z])[a-zA-Z\d!?_.$&%\-]{8,30}/
  validates :password, length: { in: 8..30 }, format: { with: VALID_PASSWORD_REGEX }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  VALID_EMAIL_REGEX = /[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}/
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, unless: :authentication
  validates :nickname, presence: true, length: { maximum: 30 }

  attr_accessor :games

  def save
    return false if invalid?

    user = User.new(email:, password:, password_confirmation:, nickname:)
    games&.each_key { |game_id| user.playing_games.build(game_id:) } if games.present?

    user.save!

    true
  end
end