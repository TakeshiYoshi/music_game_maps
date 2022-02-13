require "rails_helper"

RSpec.describe Shared::LabelComponent, type: :component do
  subject(:component) { described_class.new(name: 'test_label', class: 'test_class') }

  it { is_expected.to be_render }
end
