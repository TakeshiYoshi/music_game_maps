class ApplicationController < ActionController::Base
  before_action :set_search
  before_action :local_set

  private

  def set_search
    search_hash = {}
    search_hash = params[:q].to_unsafe_hash.transform_values { |v| v.split(/[ |　]/) } if params[:q]
    search_hash = search_hash.transform_keys { |_k| :name_cont_all } if Shop.ransack(search_hash).result.size.zero?
    search_hash = search_hash.transform_keys { |_k| :address_cont_all } if Shop.ransack(search_hash).result.size.zero?
    @q = Shop.ransack(params[:q]) # 検索フィールドに検索ワードを残すため
    @shops = Shop.ransack(search_hash).result
  end

  def local_set
    @prefectures = Prefecture.all
    @cities = Prefecture.find(session[:prefecture_id]).cities if session[:prefecture_id]
  end
end
