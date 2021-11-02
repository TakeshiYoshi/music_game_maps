require 'rails_helper'

RSpec.describe "Admin::UserReviews", type: :system do
  let!(:admin_user) { create(:user, role: 'admin') }

  before do
    create_list(:user_review, 2)
    admin_user.activate!
    login admin_user
  end

  context 'ユーザー投稿一覧ページへアクセスする' do
    it '全ユーザー投稿の情報が表示されること' do
      visit admin_user_reviews_path
      expect(page.all('.table-striped tbody tr').length).to eq(UserReview.count), '全ユーザー投稿の情報が表示されていません'
    end
  end

  context 'ユーザー投稿一覧ページで削除ボタンを押す' do
    it 'ユーザー投稿が削除されること' do
      visit admin_user_reviews_path
      expect {
        page.accept_confirm do
          page.all('a.bg-danger').last.click
        end
        sleep 0.5
      }.to change { UserReview.count }.by(-1), 'ユーザー投稿が削除されていません'
    end
  end
end
