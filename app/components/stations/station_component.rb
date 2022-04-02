# frozen_string_literal: true

class Stations::StationComponent < ViewComponent::Base
  def initialize(station:)
    @station = station
  end

  private

  attr_reader :station
end
