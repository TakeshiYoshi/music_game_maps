class ShopsController < ApplicationController
  before_action :set_filter, only: %i[index]
  before_action :set_shops_lat_and_lng, only: %i[index]

  def index
    @shops_filter = @shops_filter.includes(:games).page(params[:page]).per(session[:number_of_searches])
  end

  def show
    @shop = Shop.includes([:games, { user_reviews: :games }]).find(params[:id])
    @user_review = UserReview.new(shop_id: @shop.id) # テストが上手く動作しないため左記のような記述にしています
  end

  private

  def set_filter # rubocop:disable Metrics/CyclomaticComplexity
    @shops_filter = @shops
    @shops_filter = @shops_filter.in_prefecture(session[:prefecture_id]) if session[:prefecture_id]
    @shops_filter = @shops_filter.in_city(session[:city_id]) if session[:city_id]
    session[:games]&.each do |game_id, should_filter|
      if should_filter
        game = Game.find(game_id)
        @shops_filter = Shop.where(id: @shops_filter.includes(:games).map { |s| s.id if s.games.include?(game) }.compact)
      end
    end
    @shops_filter = sort_shops(@shops_filter)
  end

  def sort_shops(shops)
    if session[:lat]
      # 地図検索が有効の場合、指定地点周辺順にソート
      shops.by_distance(origin: [session[:lat], session[:lng]])
    elsif cookies.permanent[:location_lat]
      # 地図検索が無効で現在位置が有効の場合、現在位置に近い順でソート
      shops.by_distance(origin: [cookies.permanent[:location_lat], cookies.permanent[:location_lng]])
    else
      shops
    end
  end

  def set_shops_lat_and_lng
    gon.shops_lat_and_lng = @shops_filter.includes(:games).page(params[:page]).per(session[:number_of_searches]).to_json only: %i[id lat lng]
  end
end
