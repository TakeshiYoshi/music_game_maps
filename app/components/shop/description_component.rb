# frozen_string_literal: true

class Shop::DescriptionComponent < ViewComponent::Base
  def initialize(shop:)
    @shop = shop
  end

  private

  attr_reader :shop
end
