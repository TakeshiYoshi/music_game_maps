class ApplicationController < ActionController::Base
  before_action :set_filter
  before_action :set_search
  before_action :local_set

  private

  def set_filter
    @shops_filter = Shop.all
    @shops_filter = @shops_filter.in_prefecture(session[:prefecture_id]) if session[:prefecture_id].present?
    @shops_filter = @shops_filter.in_city(session[:city_id]) if session[:city_id].present?
  end

  def set_search
    @q = @shops_filter.ransack(params[:q])
    @shops = @q.result.includes(:games).page(params[:page])
  end

  def local_set
    @prefectures = Prefecture.all.as_json only: %i[id name]
    @cities = Prefecture.find(session[:prefecture_id]).cities.as_json only: %i[id name] if session[:prefecture_id].present?
  end
end
