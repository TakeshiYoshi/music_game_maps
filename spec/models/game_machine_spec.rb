require 'rails_helper'

RSpec.describe GameMachine, type: :model do
  it '店舗とゲームの組み合わせは一意であること' do
    shop = create(:shop)
    game = create(:game)
    game_machine = create(:game_machine, shop: shop, game: game)
    another_game_machine = build(:game_machine, shop: shop, game: game)
    another_game_machine.valid?
    expect(another_game_machine.errors[:shop_id]).to include('はすでに存在します')
  end

  it '設置台数は0~99の範囲内にあること' do
    game_machine = build(:game_machine, count: 100)
    game_machine.valid?
    expect(game_machine.errors[:count]).to include('は99以下の値にしてください')

    game_machine = build(:game_machine, count: -1)
    game_machine.valid?
    expect(game_machine.errors[:count]).to include('は0以上の値にしてください')
  end
end
