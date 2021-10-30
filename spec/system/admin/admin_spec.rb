require 'rails_helper'

RSpec.describe 'Admin', type: :system do
  let!(:admin_user) { create(:user, role: 'admin') }
  let!(:general_user) { create(:user) }

  before do
    admin_user.activate!
    general_user.activate!
  end

  context '管理者ユーザーでログインし管理画面にアクセス' do
    it 'アクセス出来ること' do
      login admin_user
      visit admin_root_path
      expect(current_path).to eq(admin_root_path), '管理画面にアクセス出来ていません'
    end
  end

  context '一般ユーザーでログインし管理画面にアクセス' do
    it 'ルートページへリダイレクトされること' do
      login general_user
      visit admin_root_path
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
    end
  end

  context 'ログインせずに管理画面にアクセス' do
    it 'ルートページへリダイレクトされること' do
      visit admin_root_path
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
    end
  end
end
