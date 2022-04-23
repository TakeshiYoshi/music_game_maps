# frozen_string_literal: true

class Shops::DescriptionListComponent < ViewComponent::Base
  renders_one :description_content

  def initialize(shop:, attribute:)
    @shop = shop
    @attribute = attribute
  end

  private

  attr_reader :shop, :attribute
end
