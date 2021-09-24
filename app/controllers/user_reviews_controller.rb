class UserReviewsController < ApplicationController
  def create
    @shop = Shop.find(params[:shop_id])
    @user_review = @shop.user_reviews.new(user_review_params)
    format_images! @user_review
    if @user_review.save
      @user_review.create_about_games(params[:games])
      redirect_to shop_path(params[:shop_id]), success: t('.success')
    else
      render 'shops/show'
    end
  end

  def destroy
    user_review = current_user.user_reviews.find(params[:id])
    authorize user_review
    user_review.destroy
    redirect_back(fallback_location: shop_path(params[:shop_id]))
  end

  private

  def user_review_params
    params.require(:user_review).permit(:body, :user_id, { images: [] })
  end

  def format_images!(user_review)
    # 5枚以上写真が投稿された際は切り捨てる
    user_review.images.slice!(4..-1)
  end
end
