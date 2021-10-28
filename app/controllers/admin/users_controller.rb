class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all.includes(:user_reviews).page(params[:page]).per(100)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path
  end
end
