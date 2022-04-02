class StationsController < ApplicationController
  def index
    @stations = Station.where('name LIKE ?', "%#{params[:name]}%").includes(:line).limit(15)
  end
end
