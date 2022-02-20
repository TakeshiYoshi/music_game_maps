class User::ProfileForm
  include ActiveModel::Model

  attr_accessor :games, :nickname, :description, :avatar

  validates :nickname, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 300 }

  delegate :persisted?, to: :user

  def initialize(attributes = nil, user: User.new, games: nil)
    @user = user
    @games = games
    attributes ||= default_attributes
    super(attributes)
  end

  def update
    return false if invalid?

    user.games.destroy_all
    build_playing_games(games:)

    user.update!(nickname:, description:)
    user.update!(avatar:) if avatar.present?

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_model
    user
  end

  private

  attr_reader :user

  def build_playing_games(games:)
    return if games.blank?

    games&.each_key { |game_id| user.playing_games.build(game_id:) }
  end

  def default_attributes
    {
      nickname: user.nickname,
      description: user.description,
      avatar: user.avatar
    }
  end
end
