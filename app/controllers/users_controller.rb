class UsersController < ApplicationController
  include CryptableUid

  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_params, only: %i[new_with_twitter]

  def new
    @user_form = UserForm.new
  end

  def create
    @user_form = UserForm.new(user_form_params, games: params[:games])
    if @user_form.save
      redirect_to login_url, success: t('.success')
    else
      render :new
    end
  end

  def new_with_twitter
    @user_form = UserForm.new
    @nickname = params[:nickname]
  end

  def create_with_twitter
    @user_form = UserForm.new(user_form_params, games: params[:games], provider: params[:provider], uid: decrypt_uid(params[:uid]))
    if @user_form.save
      redirect_to login_url, success: t('.success')
    else
      render :new_with_twitter
    end
  end

  def show
    @user_reviews = @user.user_reviews.includes(:shop).order(created_at: :desc)
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to edit_user_url(@user), success: t('.success')
    else
      render :edit
    end
  end

  def activate
    @user = User.load_from_activation_token(params[:id])
    if @user
      @user.activate!
      redirect_to login_url, success: t('.success')
    else
      not_authenticated
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to root_url, success: t('.success')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :anonymous, :theme).to_h
  end

  def user_form_params
    params.require(:user_form).permit(:email, :password, :password_confirmation, :nickname, :description, :avatar, :anonymous)
  end

  def require_params
    redirect_to root_path unless params[:provider] && params[:uid]
  end
end
