class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to root_url, success: t('.success')
  end

  def edit; end

  def update
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to root_url, success: t('.success')
    else
      render :edit
    end
  end

  private

  def set_user
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    not_authenticated if @user.blank?
  end
end
