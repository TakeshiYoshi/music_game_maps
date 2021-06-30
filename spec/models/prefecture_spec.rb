require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  it '都道府県名は必須項目であること' do
    prefecture = build(:prefecture, name: nil)
    prefecture.valid?
    expect(prefecture.errors[:name]).to include('を入力してください')
  end

  it '都道府県名は一意であること' do
    prefecture = create(:prefecture)
    another_prefecture = build(:prefecture, name: prefecture.name)
    another_prefecture.valid?
    expect(another_prefecture.errors[:name]).to include('はすでに存在します')
  end
end
