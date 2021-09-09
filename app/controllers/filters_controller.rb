class FiltersController < ApplicationController
  def create # rubocop:disable Metrics/AbcSize
    if params[:prefecture]
      session.delete :lat
      session.delete :lng
    end
    session[:prefecture_id] = params[:prefecture]
    session[:city_id] = params[:city]
    # string to boolean
    session[:games] = params[:games].to_unsafe_hash.transform_values { |v| v == 'true' } if params[:games]
    session[:number_of_searches] = params[:number_of_searches]
    redirect_to root_path
  end

  def destroy
    session.delete :prefecture_id
    session.delete :city_id
    session.delete :games
    redirect_to root_path
  end

  def clear_near_shops_search
    session.delete :lat
    session.delete :lng
    redirect_to root_path, map: t('defaults.map_flash_message.clear_near_shops_search')
  end

  def cities_select
    cities = Prefecture.find_by(id: params[:id]).cities
    render json: cities.all.to_json(only: %i[id name])
  end

  def near_shops_search
    session[:lat] = params[:lat]
    session[:lng] = params[:lng]
    session.delete :prefecture_id
    session.delete :city_id
    redirect_to root_path, map: t('defaults.map_flash_message.near_shops_search')
  end

  def set_location
    cookies.permanent[:location_lat] = params[:lat]
    cookies.permanent[:location_lng] = params[:lng]
  end
end
