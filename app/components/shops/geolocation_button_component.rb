# frozen_string_literal: true

class Shops::GeolocationButtonComponent < ViewComponent::Base
  def initialize(location:)
    @location = location
  end

  private

  attr_reader :location

  def button_classes
    classes = ['icon-container']
    classes << 'icon-blue' if location

    classes
  end

  def location?
    location
  end
end
