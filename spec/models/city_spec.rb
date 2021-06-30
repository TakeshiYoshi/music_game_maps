require 'rails_helper'

RSpec.describe City, type: :model do
  it '市区町村名は必須項目であること' do
    city = build(:city, name: nil)
    city.valid?
    expect(city.errors[:name]).to include('を入力してください')
  end

  it '市区町村名は一意であること' do
    city = create(:city)
    another_city = build(:city, name: city.name)
    another_city.valid?
    expect(another_city.errors[:name]).to include('はすでに存在します')
  end
end
