require 'rails_helper'

RSpec.describe Shop, type: :model do
  it '店名は必須項目であること' do
    shop = build(:shop, name: nil)
    shop.valid?
    expect(shop.errors[:name]).to include('を入力してください')
  end

  it '店名は一意であること' do
    shop = create(:shop)
    another_shop = build(:shop, name: shop.name)
    another_shop.valid?
    expect(another_shop.errors[:name]).to include('はすでに存在します')
  end
end
