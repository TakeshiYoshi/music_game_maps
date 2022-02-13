require "rails_helper"

RSpec.describe Shop::BadgeComponent, type: :component do
  let(:game) { create(:game, title: 'GAME BEAT') }
  let(:shop) { create(:shop) }
  let(:game_machine) { create(:game_machine, game:, shop:) }

  subject(:component) { described_class.new(game_machine:) }

  it { is_expected.to be_render }
end
