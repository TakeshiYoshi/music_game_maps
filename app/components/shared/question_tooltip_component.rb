# frozen_string_literal: true

class Shared::QuestionTooltipComponent < ViewComponent::Base
  def initialize(text:)
    @text = text
  end

  private

  attr_reader :text
end
