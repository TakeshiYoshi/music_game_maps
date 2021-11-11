require 'rails_helper'

RSpec.describe "Admin::ShopHistories", type: :system do
  let!(:admin_user) { create(:user, role: 'admin') }
  let!(:shop) { create(:shop) }
  let!(:game) { create(:game) }
  let!(:game_machine) { create(:game_machine, game: game, shop: shop) }
  let!(:shop_history) { create(:shop_history, shop: shop, user: admin_user, website: 'http://hoge.com', games: shop.game_machines_to_hash) }

  before do
    admin_user.activate!
    login admin_user
  end

  context '未承認の店舗履歴がある場合' do
    it '管理画面サイドメニューに「NEW」バッジが表示されること' do
      visit admin_root_path
      expect(page.all('.bg-success', text: 'NEW').length).to eq(1)
    end
  end

  context '店舗履歴を投稿する' do
    it '管理画面店舗履歴一覧に未承認の店舗履歴が一覧表示されること' do
      create_list(:shop_history, 10, shop: shop, user: admin_user)
      visit new_shop_shop_history_path(shop)
      fill_in 'shopName', with: 'hogehogefugafuga'
      fill_in 'shopWebsite', with: 'http://www.hoge.com'
      click_button '情報の更新を申請する'
      visit admin_shop_histories_path
      expect(page.all('.main-card').length).to eq(ShopHistory.draft.count), '管理画面店舗履歴一覧に未承認の店舗履歴が一覧表示されていません'
    end
  end

  context '投稿された店舗履歴を承認する' do
    it '承認された店舗履歴のstatusがpublishedになること' do
      visit admin_shop_histories_path
      click_on '承認する'
      shop_history.reload
      expect(shop_history.status).to eq('published'), '承認された店舗履歴のstatusがpublishedになっていません'
    end

    it '承認された店舗履歴が一覧画面に表示されないこと' do
      visit admin_shop_histories_path
      click_on '承認する'
      expect(page.all('.main-card').length).to be_zero, '承認された店舗履歴が一覧画面に表示されています'
    end

    it '承認された店舗履歴の内容がShopモデルに反映されること' do
      visit admin_shop_histories_path
      click_on '承認する'
      shop.reload
      expect(shop.website).to eq('http://hoge.com'), '承認された店舗履歴の内容がShopモデルに反映されていません'
    end
  end

  context '投稿された店舗履歴を承認しない' do
    it '未承認の店舗履歴が削除されること' do
      expect {
        visit admin_shop_histories_path
        click_on '承認しない'
      }.to change { ShopHistory.count }.by(-1), '未承認の店舗履歴が削除されていません'
    end
  end
end
