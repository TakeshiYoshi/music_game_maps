# frozen_string_literal: true

class Shops::BadgeComponent < ViewComponent::Base
  with_collection_parameter :game_machine

  def initialize(game_machine:)
    @game_machine = game_machine
  end

  private

  attr_reader :game_machine

  def badge_classes
    classes = ['m-badge__badge']

    classes << 'target' if session[:games]&.keys&.include?(game_machine.game.id.to_s)

    classes
  end

  def count_classes
    classes = ['m-badge__badge-count']

    classes << 'target' if session[:games]&.keys&.include?(game_machine.game.id.to_s)

    classes
  end
end
