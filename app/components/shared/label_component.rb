# frozen_string_literal: true

class Shared::LabelComponent < ViewComponent::Base
  def initialize(name:, **options)
    @name = name
    @options = options
  end

  private

  attr_reader :name, :options
end
