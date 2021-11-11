require 'rails_helper'

RSpec.describe ShopHistory, type: :model do
  it 'websiteは正しいフォーマットで入力されていること' do
    shop_history = build(:shop_history, website: 'hogehoge://www.hoge.fuga')
    shop_history.valid?
    expect(shop_history.errors[:website]).to include('は不正な値です')
  end

  it 'statusの初期値がdraftであること' do
    shop_history = build(:shop_history)
    expect(shop_history.status).to eq('draft')
  end
end
