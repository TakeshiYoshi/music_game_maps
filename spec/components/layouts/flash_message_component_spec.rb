require "rails_helper"

RSpec.describe Layouts::FlashMessageComponent, type: :component do
  let(:flash) { {success: 'flash message for success'} }
  subject(:component) { described_class.new(flash:) }

  it { is_expected.to be_render }
end
