require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'メール, パスワード, ニックネームが正しく入力されていれば有効であること' do
    expect(user).to be_valid
  end

  it 'メールアドレスは必須項目であること' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include('を入力してください')
  end

  it 'メールアドレスは一意であること' do
    user
    another_user = build(:user, email: user.email)
    another_user.valid?
    expect(another_user.errors[:email]).to include('はすでに存在します')
  end

  it 'メールアドレスが256文字以上なら無効であること' do
    user = build(:user, email: "#{'a'*248}@foo.bar") # 256文字
    user.valid?
    expect(user.errors[:email]).to include('は255文字以内で入力してください')
  end

  it 'メールアドレスは正しいフォーマットで入力されていること' do
    user_1 = build(:user, email: 'test@foo,bar')
    user_2 = build(:user, email: 'test:foo.bar')
    user_3 = build(:user, email: 'test@foobar')
    user_1.valid?
    user_2.valid?
    user_3.valid?
    expect(user_1.errors[:email]).to include('は不正な値です')
    expect(user_2.errors[:email]).to include('は不正な値です')
    expect(user_3.errors[:email]).to include('は不正な値です')
  end

  it 'メールアドレスの重複チェックは大小区別されないこと' do
    user_small_address = create(:user)
    user_large_address = build(:user, email: user_small_address.email.upcase)
    user_large_address.valid?
    expect(user_large_address.errors[:email]).to include('はすでに存在します')
  end

  it 'ニックネームは必須項目であること' do
    user = build(:user, nickname: nil)
    user.valid?
    expect(user.errors[:nickname]).to include('を入力してください')
  end

  it 'ニックネームは30文字以内であること' do
    user = build(:user, nickname: 'a'*31)
    user.valid?
    expect(user.errors[:nickname]).to include('は30文字以内で入力してください')
  end

  it '自己紹介は300文字以内であること' do
    user = build(:user, description: 'a'*301)
    user.valid?
    expect(user.errors[:description]).to include('は300文字以内で入力してください')
  end

  it 'パスワードは8文字以上であること' do
    user = build(:user, password: 'a'*7)
    user.valid?
    expect(user.errors[:password]).to include('は8文字以上で入力してください')
  end

  it 'パスワード再入力はパスワードと一致していること' do
    user = build(:user, password_confirmation: 'foobarfoobar')
    user.valid?
    expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
  end
end
