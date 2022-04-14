require 'rails_helper'

RSpec.describe "Admin::ShopFixRequests", type: :system do
  let!(:admin_user) { create(:user, role: 'admin') }
  let!(:shop) { create(:shop) }
  let!(:shop_fix_request) { create(:shop_fix_request, shop: shop, status: :posted) }

  before do
    admin_user.activate!
    login admin_user
  end

  context '未承認の修正依頼がある場合' do
    it '管理画面サイドメニューに「NEW」バッジが表示されること' do
      visit admin_root_path
      expect(page.all('.bg-success', text: 'NEW').length).to eq(1), '管理画面サイドメニューに「NEW」バッジが表示されていません'
    end
  end

  context '未承認の修正依頼がない場合' do
    it '管理画面サイドメニューに「NEW」バッジが表示されないこと' do
      shop.shop_fix_requests.destroy_all
      visit admin_root_path
      expect(page.all('.bg-success', text: 'NEW').length).to be_zero, '管理画面サイドメニューに「NEW」バッジが表示されています'
    end
  end

  context '修正依頼を投稿する' do
    it '管理画面修正依頼一覧に未承認の修正依頼が一覧表示されること' do
      create_list(:shop_fix_request, 10, shop: shop, status: :posted)
      visit admin_shop_fix_requests_path
      expect(page.all('.main-card').length).to eq(ShopFixRequest.posted.count), '管理画面修正依頼一覧に未承認の修正依頼が一覧表示されていません'
    end
  end

  context '投稿された修正依頼を承認する' do
    it '承認された修正依頼のstatusがcheckedになること' do
      visit admin_shop_fix_requests_path
      click_on '修正完了'
      has_css?('p', text: '未確認の修正依頼がありません')
      shop_fix_request.reload
      expect(shop_fix_request.status).to eq('checked'), '承認された修正依頼のstatusがcheckedになっていません'
    end

    it '承認された修正依頼が一覧画面に表示されないこと' do
      visit admin_shop_fix_requests_path
      click_on '修正完了'
      has_css?('p', text: '未確認の修正依頼がありません')
      expect(page.all('.main-card').length).to be_zero, '承認された修正依頼が一覧画面に表示されています'
    end
  end
end