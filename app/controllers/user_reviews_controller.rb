class UserReviewsController < ApplicationController
  def create
    @shop = Shop.find(params[:shop_id])
    @user_review_form = UserReviewForm.new(user_review_form_params)
    @user_review_form.games = params[:games]
    if @user_review_form.save
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

  def user_review_form_params
    params.require(:user_review_form).permit(:body, :user_id, :shop_id, { images: [] })
  end
end
