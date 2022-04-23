# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShopStationDecorator do
  let(:shop_station) { ShopStation.new.extend ShopStationDecorator }
  subject { shop_station }
  it { should be_a ShopStation }
end
