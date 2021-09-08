class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update edit_profile update_profile]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.create_playing_games(params[:games])
      redirect_to login_url, success: t('.success')
    else
      render :new
    end
  end

  def show; end

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

  def edit_profile
    authorize @user
  end

  def update_profile
    authorize @user
    if @user.update(user_params)
      @user.games.destroy_all
      @user.create_playing_games(params[:games])
      redirect_to @user, success: t('.success')
    else
      render :edit_profile
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nickname, :description, :avatar, :anonymous)
  end
end
