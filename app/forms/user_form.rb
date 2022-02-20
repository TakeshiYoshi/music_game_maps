class UserForm
  include ActiveModel::Model

  attr_accessor :games, :email, :password, :password_confirmation, :nickname, :provider, :uid, :anonymous

  VALID_PASSWORD_REGEX = /(?=.*?[a-z])(?=.*?[A-Z])[a-zA-Z\d!?_.$&%\-]{8,30}/
  validates :password, length: { in: 8..30 }, format: { with: VALID_PASSWORD_REGEX }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  VALID_EMAIL_REGEX = /[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}/
  if @provider && @uid
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
    validate :validate_email_on_duplication
  end

  delegate :persisted?, to: :user

  def initialize(attributes = nil, user: User.new, games: nil, provider: nil, uid: nil)
    @user = user
    @games = games
    @provider = provider
    @uid = uid
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    user.build_authentication(provider:, uid:) if oauth_sigup?
    build_playing_games(games:)

    return false if invalid?

    user.update!(email: email&.downcase, password:, password_confirmation:, nickname:)

    user.activate! if oauth_sigup?

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_model
    user
  end

  private

  attr_reader :user

  def validate_email_on_duplication
    errors.add(:email, :taken, value: email) if User.exists?(email: email&.downcase)
    false
  end

  def oauth_sigup?
    @provider && @uid
  end

  def build_playing_games(games:)
    return if games.blank?

    games&.each_key { |game_id| user.playing_games.build(game_id:) }
  end

  def default_attributes
    {
      email: user.email,
      anonymous: user.anonymous
    }
  end
end
