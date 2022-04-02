require 'rails_helper'

RSpec.describe Company, type: :model do
  it '鉄道会社名は必須項目であること' do
    company = build(:company, name: nil)
    company.valid?
    expect(company.errors[:name]).to include('を入力してください')
  end
end
