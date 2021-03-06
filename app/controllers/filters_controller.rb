class FiltersController < ApplicationController
  def create
    @filter_form = FilterForm.new(filter_form_params)
    @filter_form.session_hash.each do |k, v|
      session[k] = v
      session.delete k if v.blank?
    end
    @shops = sort_shops(@shops).includes([:games, :shop_histories, { shop_stations: { station: :line } }]).page(params[:page]).per(session[:number_of_searches])
    set_filter
  end

  def destroy
    session.delete :prefecture_id
    session.delete :city_id
    session.delete :games
    session.delete :number_of_searches
    @shops = sort_shops(@shops).includes([:games, :shop_histories, { shop_stations: { station: :line } }]).page(params[:page]).per(session[:number_of_searches])
    set_filter
  end

  def clear_near_shops_search # rubocop:disable Metrics/AbcSize
    session.delete :lat
    session.delete :lng
    @shops = sort_shops(@shops).includes([:games, :shop_histories, { shop_stations: { station: :line } }]).page(params[:page]).per(session[:number_of_searches])
    set_filter
    flash.now[:map] = t('defaults.map_flash_message.clear_near_shops_search')
    if cookies.permanent[:location_lat]
      # 現在位置が有効の場合最寄り駅を5件取得
      @stations = Station.by_distance(origin: [cookies.permanent[:location_lat], cookies.permanent[:location_lng]]).includes(:line).limit(5)
    else
      @station = nil
    end
  end

  def cities_select
    cities = Prefecture.find_by(id: params[:id]).cities
    render json: cities.all.to_json(only: %i[id name])
  end

  def near_shops_search # rubocop:disable Metrics/AbcSize
    session[:lat] = params[:lat]
    session[:lng] = params[:lng]
    session[:search_type] = params[:type]
    session.delete :prefecture_id
    session.delete :city_id
    @shops = sort_shops(@shops).includes([:games, :shop_histories, { shop_stations: { station: :line } }]).page(params[:page]).per(session[:number_of_searches])
    set_filter
    flash.now[:map] = if session[:search_type] == 'location'
                        t('defaults.map_flash_message.near_shops_search')
                      else
                        t('defaults.map_flash_message.train_search')
                      end
  end

  def set_location
    cookies.permanent[:location_lat] = params[:lat]
    cookies.permanent[:location_lng] = params[:lng]

    @shops = sort_shops(@shops).includes([:games, :shop_histories, { shop_stations: { station: :line } }]).page(params[:page]).per(session[:number_of_searches])
    set_filter
  end

  private

  def set_filter
    @shops_filter = @shops
    @shops_filter = @shops_filter.in_prefecture(session[:prefecture_id]) if session[:prefecture_id]
    @shops_filter = @shops_filter.in_city(session[:city_id]) if session[:city_id]
    if session[:games]
      select_games = session[:games].select do |_game_id, should_filter|
        should_filter
      end.keys.map(&:to_i)
      query = []
      select_games.each do |game_id|
        query << "games_info LIKE '%\"#{game_id}\"%'"
      end
      @shops_filter = @shops_filter.where(query.join(' AND '))
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

  def filter_form_params
    params.require(:filter).permit(:number_of_searches, games: {})
  end
end
