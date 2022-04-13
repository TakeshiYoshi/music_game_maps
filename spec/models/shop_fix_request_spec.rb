require 'rails_helper'

RSpec.describe ShopFixRequest, type: :model do
  it '各報告は必須項目であること' do
    shop_fix_request = build(:shop_fix_request, not_exist: nil, duplicate: nil, fix_shop_info: nil)
    shop_fix_request.valid?
    expect(shop_fix_request.errors[:not_exist]).to include('を入力してください')
    expect(shop_fix_request.errors[:duplicate]).to include('を入力してください')
    expect(shop_fix_request.errors[:fix_shop_info]).to include('を入力してください')
  end

  it '本文が1000文字を超える場合無効であること' do
    shop_fix_request = build(:shop_fix_request, body: 'a'*1001)
    shop_fix_request.valid?
    expect(shop_fix_request.errors[:body]).to include('は1000文字以内で入力してください')
  end
end
