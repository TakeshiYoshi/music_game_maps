require "rails_helper"

RSpec.describe Shop::TwitterComponent, type: :component do
  subject(:component) { described_class.new(twitter_id: 'otomap_net') }

  it { is_expected.to be_render }
end
