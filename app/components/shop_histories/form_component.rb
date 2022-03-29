# frozen_string_literal: true

class ShopHistories::FormComponent < ViewComponent::Base
  def initialize(shop_history:, current_user:)
    @shop_history = shop_history
    @current_user = current_user
  end

  private

  attr_reader :shop_history, :current_user
end
