# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDecorator do
  let!(:user) { create(:user, anonymous: true) }
  before { ActiveDecorator::Decorator.instance.decorate user }

  describe 'nickname_in_review' do
    context 'Userモデルのanonymousがtrue' do
      it '文字列「匿名」が返される' do
        expect(user.nickname_in_review).to eq('匿名'), '文字列「匿名」が返されていません'
      end
    end

    context 'Userモデルのanonymousがfalse' do
      it 'Userモデルに設定したニックネームが返される' do
        user.update(anonymous: false)
        expect(user.nickname_in_review).to eq(user.nickname), 'Userモデルに設定したニックネームが返されていません'
      end
    end
  end

  describe 'avatar_url_in_review' do
    context 'Userモデルのanonymousがtrue' do
      it '文字列「/images/icon_default.png」が返される' do
        expect(user.avatar_url_in_review).to eq('/images/icon_default.png'), '文字列「/images/icon_default.png」が返されていません'
      end
    end

    context 'Userモデルのanonymousがfalse' do
      it 'Userモデルに設定したアバター画像のURLが返される' do
        user.update(anonymous: false)
        expect(user.avatar_url_in_review).to eq(user.avatar.url), 'Userモデルに設定したアバター画像のURLが返されていません'
      end
    end
  end
end

# I18n.tメソッドを動作させるため
def t(string, options={})
  I18n.t(string, options)
end