# frozen_string_literal: true

class Shops::DescriptionComponent < ViewComponent::Base
  def initialize(shop:)
    @shop = shop
  end

  private

  attr_reader :shop
end
