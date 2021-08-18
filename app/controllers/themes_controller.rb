class ThemesController < ApplicationController
  def create
    session[:theme] = params[:theme]
  end
end
