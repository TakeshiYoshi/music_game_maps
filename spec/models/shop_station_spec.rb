require 'rails_helper'

RSpec.describe ShopStation, type: :model do
  it '店舗と駅の組み合わせは一意であること' do
    shop = create(:shop)
    station = create(:station)
    shop_station = create(:shop_station, shop: shop, station: station)
    another_shop_station = build(:shop_station, shop: shop, station: station)
    another_shop_station.valid?
    expect(another_shop_station.errors[:shop_id]).to include('はすでに存在します')
  end
end
