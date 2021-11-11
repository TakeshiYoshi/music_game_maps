class Admin::ShopHistoriesController < Admin::BaseController
  before_action :set_shop_history, only: %i[update destroy]
  def index
    @shop_histories = ShopHistory.draft.includes(%i[user shop]).page(params[:page]).per(20)
    @games = Game.all
  end

  def destroy
    @shop_history.destroy
    redirect_to admin_shop_histories_path
  end

  def update
    @shop_history.update(status: :published)
    @shop_history.shop.update_to_latest
    redirect_to admin_shop_histories_path
  end

  private

  def set_shop_history
    @shop_history = ShopHistory.find(params[:id])
  end
end
