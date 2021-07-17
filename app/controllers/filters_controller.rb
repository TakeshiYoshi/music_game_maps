class FiltersController < ApplicationController
  def create
    if params[:prefecture]
      session.delete :lat
      session.delete :lng
    end
    session[:prefecture_id] = params[:prefecture]
    session[:city_id] = params[:city]
    session[:games] = params[:games]
    redirect_to root_path
  end

  def destroy
    session.delete :prefecture_id
    session.delete :city_id
    session.delete :games
    redirect_to root_path
  end

  def clear_location
    session.delete :lat
    session.delete :lng
    redirect_to root_path, notice: '周辺検索設定をクリアしました'
  end

  def cities_select
    cities = Prefecture.find_by(id: params[:id]).cities
    render json: cities.all.to_json(only: %i[id name])
  end

  def set_location
    session[:lat] = params[:lat]
    session[:lng] = params[:lng]
    session.delete :prefecture_id
    session.delete :city_id
    redirect_to root_path
  end
end
