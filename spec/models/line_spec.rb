require 'rails_helper'

RSpec.describe Line, type: :model do
  it '路線名は必須項目であること' do
    line = build(:line, name: nil)
    line.valid?
    expect(line.errors[:name]).to include('を入力してください')
  end

  it '路線名は一意であること' do
    line = create(:line)
    another_line = build(:line, name: line.name)
    another_line.valid?
    expect(another_line.errors[:name]).to include('はすでに存在します')
  end
end
