class Admin::ShopHistoriesController < Admin::BaseController
  def index
    @shop_histories = ShopHistory.draft.includes(%i[user shop]).page(params[:page]).per(20)
    @games = Game.all
  end

  def destroy
    shop_history = ShopHistory.find(params[:id])
    shop_history.destroy
    redirect_to admin_shop_histories_path
  end
end
