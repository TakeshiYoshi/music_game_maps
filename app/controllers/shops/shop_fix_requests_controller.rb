class Shops::ShopFixRequestsController < ApplicationController
  before_action :set_shop, only: %i[new create]

  def new
    @shop_fix_request = @shop.shop_fix_requests.build
  end

  def create
    @shop_fix_request = @shop.shop_fix_requests.build(shop_fix_request_params)
    puts 'a'*100
    puts shop_fix_request_params
    if values_present? && @shop_fix_request.save
      redirect_to shop_path(@shop), success: t('.success')
    else
      flash.now[:danger] = t('.danger')
      render :new
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def shop_fix_request_params
    params.require(:shop_fix_request).permit(:not_exist, :duplicate, :fix_shop_info, :body)
  end

  def values_present?
    # 無記入投稿防止用
    shop_fix_request_params.values.map{ |value| value === 'true' ? value : nil }.compact.present?
  end
end
