class ShopHistoriesController < ApplicationController
  def new
    shop = Shop.find(params[:shop_id])
    @shop_history = shop.shop_histories.new(
                      name: shop.name,
                      phone_number: shop.phone_number,
                      website: shop.website,
                      twitter_id: shop.twitter_id,
                      games: shop.game_machines_to_hash,
                      user_id: current_user.id )
  end

  def create

  end
end
