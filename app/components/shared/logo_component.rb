# frozen_string_literal: true

class Shared::LogoComponent < ViewComponent::Base
  def initialize(theme_color:, **options)
    @theme_color = theme_color
    @options = options
  end

  private

  attr_reader :theme_color, :options
end
