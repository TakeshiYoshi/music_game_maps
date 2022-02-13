require "rails_helper"

RSpec.describe Shop::DescriptionListComponent, type: :component do
  let(:shop) { create(:shop) }
  subject(:component) { described_class.new(shop:, attribute: 'address') }

  it { is_expected.to be_render }
end
