class ShopHistory < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  VALID_WEBSITE_REGEX = %r{\Ahttps?://[\w!?/+\-_~=;.,*&@#$%()'\[\]]+\z}.freeze

  mount_uploader :appearance_image, ShopHistoryAppearanceImageUploader

  validates :website, format: { with: VALID_WEBSITE_REGEX }, allow_nil: true

  def format_model(games_params) # rubocop:disable Metrics/AbcSize
    self.name = nil if name == shop.name
    self.phone_number = nil if phone_number == shop.phone_number
    self.website = nil if website == shop.website
    self.twitter_id = nil if twitter_id == shop.twitter_id
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
