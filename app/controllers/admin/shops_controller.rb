class Admin::ShopsController < Admin::BaseController
  before_action :set_shop, only: %i[show edit update destroy]

  def index
    @q = Shop.ransack(params[:q])
    @shops = @q.result.includes(%i[prefecture city]).page(params[:page]).per(100)
  end

  def show; end

  def edit; end

  def update
    if @shop.update(shop_params)
      @shop.games.destroy_all
      @shop.create_game_machines(params[:games])
      redirect_to admin_shop_path(@shop)
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to admin_shops_path
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :address, :phone_number, :website)
  end
end
