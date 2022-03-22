# frozen_string_literal: true

class Shared::LogoComponent < ViewComponent::Base
  def initialize(theme_color:, base_color:, width:)
    @theme_color = theme_color
    @base_color = base_color
    @width = width
  end

  private

  attr_reader :theme_color, :base_color, :width
end
