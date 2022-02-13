require "rails_helper"

RSpec.describe Shared::PrimaryButtonComponent, type: :component do
  subject(:component) { described_class.new(text: 'label', href: 'http://example.com', class: 'test-class') }

  it { is_expected.to be_render }
end
