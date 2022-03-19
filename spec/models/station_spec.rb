require 'rails_helper'

RSpec.describe Station, type: :model do
  it '駅名は必須項目であること' do
    station = build(:station, name: nil)
    station.valid?
    expect(station.errors[:name]).to include('を入力してください')
  end
end
