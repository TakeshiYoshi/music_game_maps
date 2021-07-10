class FiltersController < ApplicationController
  def create
    session[:prefecture_id] = params[:prefecture]
    session[:city_id] = params[:city]
    redirect_back(fallback_location: root_path)
  end

  def destroy
    session.delete :prefecture_id
    session.delete :city_id
    redirect_back(fallback_location: root_path)
  end

  def cities_select
    cities = Prefecture.find_by(id: params[:id]).cities
    render json: cities.all.to_json(only: %i[id name])
  end
end
