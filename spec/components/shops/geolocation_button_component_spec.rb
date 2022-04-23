require "rails_helper"

RSpec.describe Shops::GeolocationButtonComponent, type: :component do
  subject(:component) { described_class.new(location: true) }

  it { is_expected.to be_render }
end
