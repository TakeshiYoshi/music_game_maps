class Users::ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(user_params)
      @user.games.destroy_all
      @user.create_playing_games(params[:games])
      redirect_to user_path(@user), success: t('.success')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:nickname, :description, :avatar).to_h
  end
end
