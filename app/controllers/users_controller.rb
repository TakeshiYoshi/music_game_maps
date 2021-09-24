class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update edit_profile update_profile destroy]
  before_action :require_params, only: %i[new_with_twitter]

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

  def new_with_twitter
    @user = User.new
  end

  def create_with_twitter
    @user = User.new(user_params)
    @user.build_authentication(provider: params[:provider], uid: decrypt_uid(params[:uid]))
    if @user.save
      @user.create_playing_games(params[:games])
      @user.activate!
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
    params.require(:user).permit(:email, :password, :password_confirmation, :nickname, :description, :avatar, :anonymous).to_h
  end

  def require_params
    redirect_to root_path unless params[:provider] && params[:uid]
  end

  def decrypt_uid(encrypted)
    len = ActiveSupport::MessageEncryptor.key_len
    salt = Rails.application.credentials[:twitter][:uid_salt]
    secret = Rails.application.key_generator.generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(secret)
    crypt.decrypt_and_verify(encrypted)
  end
end
