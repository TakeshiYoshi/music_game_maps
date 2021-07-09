class ApplicationController < ActionController::Base
  before_action :set_search

  def set_search
    @q = Shop.ransack(params[:q])
    @shops = @q.result.includes(:games).page(params[:page])
  end
end
