class Users::ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
    authorize @user
    @profile_form = User::ProfileForm.new(user: @user)
  end

  def update
    authorize @user

    @profile_form = User::ProfileForm.new(user_form_params, user: @user, games: params[:games])
    if @profile_form.update
      redirect_to user_path(@user), success: t('.success')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_form_params
    params.require(:profile_form).permit(:nickname, :description, :avatar).to_h
  end
end
