# frozen_string_literal: true

class Shops::SearchByTrainModalComponent < ViewComponent::Base
  def initialize(stations:)
    @stations = stations
  end

  private

  attr_reader :stations
end
