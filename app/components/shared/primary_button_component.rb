# frozen_string_literal: true

class Shared::PrimaryButtonComponent < ViewComponent::Base
  def initialize(text:, href:, **options)
    @text = text
    @href = href
    @options = options
  end

  private

  attr_reader :text, :href, :options
end
