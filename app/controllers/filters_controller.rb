class FiltersController < ApplicationController
  def create
    session[:prefecture_id] = params[:prefecture]
    session[:city_id] = params[:city]
    session[:games] = params[:games]
    session[:lat] = params[:lat]
    session[:lng] = params[:lng]
    redirect_back(fallback_location: root_path)
  end

  def destroy
    session.delete :prefecture_id
    session.delete :city_id
    session.delete :games
    session.delete :lat
    session.delete :lng
    redirect_back(fallback_location: root_path)
  end

  def cities_select
    cities = Prefecture.find_by(id: params[:id]).cities
    render json: cities.all.to_json(only: %i[id name])
  end
end
