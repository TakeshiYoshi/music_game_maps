class ApplicationController < ActionController::Base
  before_action :set_search
  before_action :local_set

  private

  def set_search
    @q = Shop.ransack(params[:q])
    @shops = @q.result
  end

  def local_set
    @prefectures = Prefecture.all.as_json only: %i[id name]
    @cities = Prefecture.find(session[:prefecture_id]).cities.as_json(only: %i[id name]) if session[:prefecture_id]
  end
end
