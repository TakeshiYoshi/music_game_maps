class Admin::UserReviewsController < Admin::BaseController
  def index
    @user_reviews = UserReview.all.includes(%i[user shop]).page(params[:page]).per(100)
  end

  def destroy
    user_review = UserReview.find(params[:id])
    user_review.destroy
    redirect_to admin_user_reviews_path
  end
end
