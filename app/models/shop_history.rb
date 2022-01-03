class ShopHistory < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  VALID_WEBSITE_REGEX = %r{\Ahttps?://[\w!?/+\-_~=;.,*&@#$%()'\[\]]+\z}.freeze

  mount_uploader :appearance_image, ShopHistoryAppearanceImageUploader

  validates :website, format: { with: VALID_WEBSITE_REGEX }, allow_nil: true

  enum status: { draft: 0, published: 1 }

  scope :draft, -> { where(status: :draft) }
  scope :published, -> { where(status: :published) }

  def format_model(games_params) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    self.name = nil if name == shop.name || name.blank?
    self.phone_number = nil if phone_number == shop.phone_number || phone_number.blank?
    self.website = nil if website == shop.website || website.blank?
    self.twitter_id = nil if twitter_id == shop.twitter_id || twitter_id.blank?
    twitter_id.delete!('@') if twitter_id&.include?('@') # @が含まれる場合は削除する
    self.games = games_params.reject { |_k, v| v.to_i.zero? }
    self.games = nil if games == shop.game_machines_to_hash
  end

  def validate
    # 全てのカラムがnilだった場合はエラーを返す
    items = [name, phone_number, website, twitter_id, games, appearance_image]
    errors.add(:base, '最低1つの情報を変更してください') unless items.any?(&:present?)
    items.any?(&:present?)
  end
end
