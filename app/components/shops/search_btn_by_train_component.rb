# frozen_string_literal: true

class Shops::SearchBtnByTrainComponent < ViewComponent::Base
  def initialize(stations:)
    @stations = stations
  end

  private

  attr_reader :stations

  def icon_classes
    classes = ['m-searchBtnByTrain-link']
    classes << 'icon-blue' if session[:lat] && session[:search_type] == 'station'

    classes
  end
end
