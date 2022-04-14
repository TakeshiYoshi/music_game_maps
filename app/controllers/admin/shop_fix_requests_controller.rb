class Admin::ShopFixRequestsController < Admin::BaseController
  def index
    @shop_fix_requests = ShopFixRequest.posted.page(params[:page]).per(20)
  end

  def update
    shop_fix_request = ShopFixRequest.find(params[:id])
    shop_fix_request.update(status: :checked)
    redirect_to admin_shop_fix_requests_path
  end
end
