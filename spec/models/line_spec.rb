require 'rails_helper'

RSpec.describe Line, type: :model do
  it '路線名は必須項目であること' do
    line = build(:line, name: nil)
    line.valid?
    expect(line.errors[:name]).to include('を入力してください')
  end
end
