require "rails_helper"

RSpec.describe Shops::DescriptionComponent, type: :component do
  let(:shop) { create(:shop) }
  subject(:component) { described_class.new(shop:) }

  it { is_expected.to be_render }
end
