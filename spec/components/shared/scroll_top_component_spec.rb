require "rails_helper"

RSpec.describe Shared::ScrollTopComponent, type: :component do
  subject(:component) { described_class.new }

  it { is_expected.to be_render }
end
