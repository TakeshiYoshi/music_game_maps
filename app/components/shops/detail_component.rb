# frozen_string_literal: true

class Shops::DetailComponent < ViewComponent::Base
  def initialize(shop:, user_review_form:, logged_in:, current_user:)
    @shop = shop
    @user_review_form = user_review_form
    @logged_in = logged_in
    @current_user = current_user
  end

  private

  attr_reader :shop, :user_review_form, :logged_in, :current_user

  def logged_in?
    logged_in
  end
end
