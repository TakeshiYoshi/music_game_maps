require 'rails_helper'

RSpec.describe "Admin::Users", type: :system do
  let!(:admin_user) { create(:user, role: 'admin') }

  before do
    create_list(:user, 2)
    admin_user.activate!
    login admin_user
  end

  context 'ユーザー一覧ページへアクセスする' do
    it '全ユーザーの情報が表示されること' do
      visit admin_users_path
      expect(page.all('.table-striped tbody tr').length).to eq(User.count), '全ユーザーの情報が表示されていません'
    end

    it '管理ユーザーは削除ボタンが表示されないこと' do
      visit admin_users_path
      # 管理ユーザーは1つのみのため削除ボタンの数は(ユーザー総数 - 1)になる
      expect(page.all('a.bg-danger').length).to eq(User.count - 1), '全ユーザーの情報が表示されていません'
    end
  end

  context 'ユーザー一覧ページで削除ボタンを押す' do
    it 'ユーザーが削除されること' do
      visit admin_users_path
      expect {
        page.accept_confirm do
          page.all('a.bg-danger').last.click
        end
        sleep 0.5
      }.to change { User.count }.by(-1), 'アカウントが削除されていません'
    end
  end
end
