class ShopsController < ApplicationController
  def index; end

  def show
    @shop = Shop.includes(:games).find(params[:id])
  end
end
