require 'rails_helper'

RSpec.describe City, type: :model do
  it '市区町村名は必須項目であること' do
    city = build(:city, name: nil)
    city.valid?
    expect(city.errors[:name]).to include('を入力してください')
  end
end
