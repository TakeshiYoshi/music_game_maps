class ShopsController < ApplicationController
  def index
    @shops = Shop.all.includes(:games).page(params[:page])
  end
end
