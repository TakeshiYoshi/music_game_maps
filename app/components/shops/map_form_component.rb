# frozen_string_literal: true

class Shops::MapFormComponent < ViewComponent::Base
  def initialize(filter_form:)
    @filter_form = filter_form
  end

  private

  attr_reader :filter_form

  def games
    Game.all
  end
end
