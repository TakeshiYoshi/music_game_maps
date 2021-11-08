class ShopHistoriesController < ApplicationController
  before_action :set_shop, only: %i[new create]

  def new
    @shop_history = @shop.shop_histories.new(
      name: @shop.name,
      phone_number: @shop.phone_number,
      website: @shop.website,
      twitter_id: @shop.twitter_id,
      games: @shop.game_machines_to_hash,
      appearance_image: @shop.appearance_image
    )
  end

  def create
    @shop_history = @shop.shop_histories.new(shop_history_params)
    @shop_history.format_model(params[:games])
    if @shop_history.validate && @shop_history.save
      redirect_to shop_path(@shop), success: t('.success')
    else
      # モデルをフォーム入力時の状態に戻す
      @shop_history.assign_attributes(shop_history_params)
      @shop_history.games = params[:games].reject { |_k, v| v.to_i.zero? }
      render :new
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def shop_history_params
    params.require(:shop_history).permit(:name, :phone_number, :website, :twitter_id, :appearance_image, :user_id)
  end
end
