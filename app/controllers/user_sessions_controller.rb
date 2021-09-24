class UserSessionsController < ApplicationController
  def new
    redirect_to root_url if logged_in?
  end

  def create
    @user = login(params[:email], params[:password], params[:remember])

    if @user
      redirect_to root_url, success: t('.success')
    else
      flash.now[:danger] = t('.danger')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, success: t('.success')
  end
end
