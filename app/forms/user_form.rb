class UserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :nickname

  VALID_PASSWORD_REGEX = /(?=.*?[a-z])(?=.*?[A-Z])[a-zA-Z\d!?_.$&%\-]{8,30}/
  validates :password, length: { in: 8..30 }, format: { with: VALID_PASSWORD_REGEX }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  VALID_EMAIL_REGEX = /[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}/
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX } #, unless: :authentication
  validate :validate_email_on_duplication
  validates :nickname, presence: true, length: { maximum: 30 }

  attr_accessor :games

  def save
    return false if invalid?

    user = User.new(email: email.downcase, password:, password_confirmation:, nickname:)
    games&.each_key { |game_id| user.playing_games.build(game_id:) } if games.present?

    user.save!

    true
  end

  private

  def validate_email_on_duplication
    errors.add(:email, :taken, value: email) if User.exists?(email: email.downcase)
  end
end
