class ShopsController < ApplicationController
  def index
    @shops = Shop.where(prefecture: Prefecture.find_by(name: '東京都')).includes(:games).page(params[:page])
  end

  def show
    @shop = Shop.includes(:games).find(params[:id])
  end
end
