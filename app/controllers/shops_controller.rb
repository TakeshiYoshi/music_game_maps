class ShopsController < ApplicationController
  def index
    @shops = Shop.where(city: City.find_by(name: '江戸川区')).includes(:games).page(params[:page])
  end
end
