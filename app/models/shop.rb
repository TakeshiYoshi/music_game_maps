class Shop < ApplicationRecord
  include Calculatorable

  belongs_to :prefecture
  belongs_to :city
  has_many :user_reviews, dependent: :destroy
  has_many :game_machines, dependent: :destroy
  has_many :games, through: :game_machines
  has_many :shop_histories, dependent: :destroy
  has_many :shop_stations, dependent: :destroy
  has_many :stations, through: :shop_stations
  has_many :shop_fix_requests, dependent: :destroy
  after_create :create_base_history unless Rails.env.test?
  after_create :create_shop_stations unless Rails.env.test?

  mount_uploader :appearance_image, ShopAppearanceImageUploader

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   lat_column_name: :lat,
                   lng_column_name: :lng

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :in_prefecture, ->(prefecture_id) { where(prefecture_id:) }
  scope :in_city, ->(city_id) { where(city_id:) }

  def create_game_machines(game_machines_params)
    game_machines_params&.each do |game_id, count|
      next if count.to_i.zero?

      game = Game.find(game_id)
      game_machine = game_machines.build(game:, count:)
      game_machine.save!
    end
  end

  def game_machines_to_hash
    game_machines.map { |game_machine| [game_machine.game.id.to_s, game_machine.count.to_s] }.to_h
  end

  def create_base_history
    return if shop_histories.present?

    shop_history = shop_histories.new(
      name:,
      phone_number:,
      website:,
      twitter_id:,
      games: game_machines_to_hash,
      appearance_image:,
      status: :published,
      user_id: User.admin.first.id
    )
    shop_history.save
  end

  def update_to_latest # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    return if shop_histories.count.zero?

    # 履歴を積み上げていき最新の状態をハッシュで取得する
    latest = {}
    shop_histories.published.each do |shop_history|
      items = { name: shop_history.name,
                phone_number: shop_history.phone_number,
                website: shop_history.website,
                twitter_id: shop_history.twitter_id,
                games: shop_history.games }
      if shop_history.appearance_image.present?
        items[:appearance_image] = if Rails.env.development?
                                     File.open(shop_history.appearance_image.file.file)
                                   else
                                     shop_history.appearance_image.url
                                   end
      end
      items.each do |key, value|
        next if value.nil?

        latest[key] = value
      end
    end
    # ハッシュ内でvalueがnilのものは削除する
    # 店舗データに最新の状態を適応する
    latest.reject { |_k, v| v.nil? }.each do |k, v|
      # game_machinesは別途作成
      next if %i[games appearance_image].include?(k)

      self[k] = v
    end
    # game_machinesを作成する
    game_machines.destroy_all
    latest[:games].each do |game_id, count|
      game_machines.create(game_id:, count:)
    end
    # appearance_imageにファイルをマウント
    if Rails.env.development?
      appearance_image.store!(latest[:appearance_image])
    else
      self.remote_appearance_image_url = latest[:appearance_image]
    end
    # データベース書き込み
    save
  end

  def games_array
    games.map(&:id)
  end

  def set_games_info
    update(games_info: games_array.map(&:to_s).to_s)
  end

  def create_shop_stations
    stations = near_stations

    stations.each do |station|
      distance = distance(lat, lng, station.lat, station.lng)

      # 距離が10km以上の場合は最寄り駅としない
      next if distance > 10_000

      ShopStation.create(shop: self, station:, distance: distance(lat, lng, station.lat, station.lng))
    end
  end

  def near_stations
    companies = []
    stations = []

    Station.by_distance(origin: [lat, lng]).limit(50).each do |s|
      # 駅を3個取得したら停止
      break if stations.length >= 3
      # 同じ会社の駅の場合はスキップ
      next if companies.include?(s.line.company) && stations.map(&:name).include?(s.name)

      companies << s.line.company
      stations << s
    end

    stations
  end
end
