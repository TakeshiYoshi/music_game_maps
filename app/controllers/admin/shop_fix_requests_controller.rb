class Admin::ShopFixRequestsController < Admin::BaseController
  def index
    @shop_fix_requests = ShopFixRequest.posted.page(params[:page]).per(20)
  end

  def destroy
    shop_fix_request = ShopFixRequest.find(params[:id])
    shop_fix_request.destroy
    redirect_to admin_shop_fix_requests_path
  end
end
