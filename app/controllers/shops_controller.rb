class ShopsController < ApplicationController
  before_action :set_filter, only: %i[index]
  before_action :set_shops_lat_and_lng, only: %i[index]

  def index
    @shops_filter = @shops_filter.includes(:games).page(params[:page])
  end

  def show
    @shop = Shop.includes(:games).find(params[:id])
  end

  private

  def set_filter
    @shops_filter = @shops
    @shops_filter = @shops_filter.in_prefecture(session[:prefecture_id]) if session[:prefecture_id]
    @shops_filter = @shops_filter.in_city(session[:city_id]) if session[:city_id]
    session[:games]&.each do |g|
      # g.first: Game.id
      # g.last: 0 => フィルターなし, 1 => フィルターあり
      if g.last == '1'
        game = Game.find(g.first.to_i)
        @shops_filter = Shop.where(id: @shops_filter.includes(:games).map { |s| s.id if s.games.include?(game) }.compact)
      end
    end
    @shops_filter = @shops_filter.by_distance(origin: [session[:lat], session[:lng]]).limit(20) if session[:lat]
  end

  def set_shops_lat_and_lng
    gon.shops_lat_and_lng = @shops_filter.includes(:games).page(params[:page]).to_json only: %i[id lat lng]
  end
end
