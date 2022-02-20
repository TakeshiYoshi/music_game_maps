class UserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :nickname
  attribute :provider
  attribute :uid

  VALID_PASSWORD_REGEX = /(?=.*?[a-z])(?=.*?[A-Z])[a-zA-Z\d!?_.$&%\-]{8,30}/
  validates :password, length: { in: 8..30 }, format: { with: VALID_PASSWORD_REGEX }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  VALID_EMAIL_REGEX = /[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}/
  if @provider && @uid
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
    validate :validate_email_on_duplication
  end
  validates :nickname, presence: true, length: { maximum: 30 }

  attr_accessor :games

  def save
    @user = User.new(email: email&.downcase, password:, password_confirmation:, nickname:)
    @user.build_authentication(provider: @provider, uid: @uid) if oauth_sigup?
    build_playing_games(games:)

    return false if invalid?

    @user.save!

    @user.activate! if oauth_sigup?

    true
  end

  def build_authentication(provider:, uid:)
    @provider = provider
    @uid = uid
  end

  private

  def validate_email_on_duplication
    errors.add(:email, :taken, value: email) if User.exists?(email: email&.downcase)
  end

  def oauth_sigup?
    @provider && @uid
  end

  def build_playing_games(games:)
    return if games.present?

    games&.each_key { |game_id| @user.playing_games.build(game_id:) }
  end
end
