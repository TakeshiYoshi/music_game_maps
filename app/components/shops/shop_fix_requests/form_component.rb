# frozen_string_literal: true

class Shops::ShopFixRequests::FormComponent < ViewComponent::Base
  def initialize(shop_fix_request:)
    @shop_fix_request = shop_fix_request
  end

  private

  attr_reader :shop_fix_request
end
