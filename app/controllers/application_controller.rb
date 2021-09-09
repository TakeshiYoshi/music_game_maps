class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError; end

  class IpAddressRejected < ActionController::ActionControllerError; end

  include Pundit
  include ErrorHandlers unless Rails.env.development?

  before_action :set_search
  before_action :set_variable_to_javascript

  add_flash_types :map, :success

  private

  def not_authenticated
    redirect_to login_url, danger: t('defaults.flash_message.login')
  end

  def set_search
    search_hash = {}
    search_hash = params[:q].to_unsafe_hash.transform_values { |v| v.split(/[ |　]/) } if params[:q]
    search_hash = search_hash.transform_keys { |_k| :name_cont_all } if Shop.ransack(search_hash).result.size.zero?
    search_hash = search_hash.transform_keys { |_k| :address_cont_all } if Shop.ransack(search_hash).result.size.zero?
    @q = Shop.ransack(params[:q]) # 検索フィールドに検索ワードを残すため
    @shops = Shop.ransack(search_hash).result
  end

  def set_variable_to_javascript # rubocop:disable Metrics/AbcSize
    gon.selectedPref = session[:prefecture_id]
    gon.selectedCity = session[:city_id]
    gon.location = [cookies.permanent[:location_lat], cookies.permanent[:location_lng]] if cookies.permanent[:location_lat]
    gon.isTest = Rails.env.test?
    gon.attend_tutorial = cookies.permanent[:attend_tutorial]
    gon.selectedCity = session[:city_id]
    gon.prefectures = Prefecture.all.to_json only: %i[id name]
    gon.cities = Prefecture.find(gon.selectedPref).cities.to_json(only: %i[id name]) if gon.selectedPref
    gon.theme = current_user.theme if logged_in?
  end
end
