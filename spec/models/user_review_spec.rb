require 'rails_helper'

RSpec.describe UserReview, type: :model do
  it '本文は必須項目であること' do
    user_review = build(:user_review, body: nil)
    user_review.valid?
    expect(user_review.errors[:body]).to include('を入力してください')
  end

  it '本文が1000文字を超える場合無効であること' do
    user_review = build(:user_review, body: 'a'*1001)
    user_review.valid?
    expect(user_review.errors[:body]).to include('は1000文字以内で入力してください')
  end
end
