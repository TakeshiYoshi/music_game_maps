require "rails_helper"

RSpec.describe Layouts::MapFlashMessageComponent, type: :component do
  let(:flash) { {map: 'flash message for map'} }
  subject(:component) { described_class.new(flash:) }

  it { is_expected.to be_render }
end
