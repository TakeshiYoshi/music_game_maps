class UserReviewsController < ApplicationController
  def create
    @shop = Shop.find(params[:shop_id])
    @user_review = @shop.user_reviews.new(user_review_params)
    if @user_review.save
      create_about_games
      redirect_to shop_path(params[:shop_id]), success: t('.success')
    else
      render 'shops/show'
    end
  end

  private

  def user_review_params
    params.require(:user_review).permit(:body, :user_id, { images: [] })
  end

  def create_about_games
    return unless params[:games]

    params[:games].each do |key, _value|
      game = Game.find(key)
      about_games = @user_review.about_games.build(game: game)
      about_games.save!
    end
  end
end
