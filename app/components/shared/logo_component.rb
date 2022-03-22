# frozen_string_literal: true

class Shared::LogoComponent < ViewComponent::Base
  def initialize(theme_color:, width:)
    @theme_color = theme_color
    @width = width
  end

  private

  attr_reader :theme_color, :width
end
