# frozen_string_literal: true

class Shop::BadgeComponent < ViewComponent::Base
  with_collection_parameter :game_machine

  def initialize(game_machine:)
    @game_machine = game_machine
  end

  private

  attr_reader :game_machine
end
