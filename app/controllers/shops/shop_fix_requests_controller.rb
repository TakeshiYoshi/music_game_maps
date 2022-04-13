class Shops::ShopFixRequestsController < ApplicationController
  def new
    @shop = Shop.find(params[:shop_id])
    @shop_fix_request = @shop.shop_fix_requests.build
  end

  def create; end
end
