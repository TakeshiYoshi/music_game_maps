require 'rails_helper'

RSpec.describe ShopFixRequest, type: :model do
  it '本文が1000文字を超える場合無効であること' do
    shop_fix_request = build(:shop_fix_request, body: 'a'*1001)
    shop_fix_request.valid?
    expect(shop_fix_request.errors[:body]).to include('は1000文字以内で入力してください')
  end
end
