# frozen_string_literal: true

class UserReviews::FormComponent < ViewComponent::Base
  def initialize(user_review_form:, shop:, current_user:)
    @user_review_form = user_review_form
    @shop = shop
    @current_user = current_user
  end

  private

  attr_reader :user_review_form, :shop, :current_user
end
