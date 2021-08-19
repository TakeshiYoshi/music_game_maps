class ThemesController < ApplicationController
  def create
    user = current_user
    user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:theme)
  end
end
