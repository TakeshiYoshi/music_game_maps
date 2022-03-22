class ShopsController < ApplicationController
  before_action :set_filter, only: %i[index]
  before_action :set_shops_lat_and_lng, only: %i[index]
  before_action :set_tutorial_cookie, only: %i[index]
  before_action :set_shop, only: %i[show edit]

  def index
    @shops_filter = @shops_filter.includes([:games, :shop_histories, { shop_stations: { station: :line } }]).page(params[:page]).per(session[:number_of_searches])
  end

  def show
    @user_review_form = UserReviewForm.new
  end

  def edit; end

  private

  def set_filter
    @shops_filter = @shops
    @shops_filter = @shops_filter.in_prefecture(session[:prefecture_id]) if session[:prefecture_id]
    @shops_filter = @shops_filter.in_city(session[:city_id]) if session[:city_id]
    if session[:games]
      select_games = session[:games].select do |_game_id, should_filter|
        should_filter
      end.keys.map(&:to_i)
      @shops_filter = @shops_filter.joins(:games).merge(Game.where(id: select_games))
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

  def set_tutorial_cookie
    cookies.permanent[:attend_tutorial] = true unless cookies.permanent[:attend_tutorial]
  end

  def set_shop
    @shop = Shop.includes([:games, { user_reviews: :games }]).find(params[:id])
  end
end
