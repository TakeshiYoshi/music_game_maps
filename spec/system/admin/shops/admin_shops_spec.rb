require 'rails_helper'

RSpec.describe "Admin::Shops", type: :system do
  let!(:admin_user) { create(:user, role: 'admin') }
  let!(:game) { create(:game, title: 'SAMPLE BEAT') }
  let!(:shop) { create(:shop) }

  before do
    create_list(:shop, 10)
    shop.game_machines.create(game: game, count: 2)
    admin_user.activate!
    login admin_user
  end

  context '店舗一覧ページへアクセスする' do
    it '全店舗の情報が表示されること' do
      visit admin_shops_path
      expect(page.all('.table-striped tbody tr').length).to eq(Shop.count), '全店舗の情報が表示されていません'
    end
  end

  context '店舗一覧ページで削除ボタンを押す' do
    it '店舗が削除されること' do
      visit admin_shops_path
      expect {
        page.accept_confirm do
          page.all('a.badge-danger').last.click
        end
        sleep 0.5
      }.to change { Shop.count }.by(-1), '店舗が削除されていません'
    end
  end

  describe '店舗情報編集' do
    context '正しい情報を入力' do
      it '店舗情報の編集が成功すること' do
        visit edit_admin_shop_path(shop)
        fill_in 'shop_name', with: 'hogehogeshop'
        fill_in 'shop_address', with: 'hogehogeaddress1-2-3'
        fill_in 'shop_phone_number', with: '0123-4567-89'
        fill_in 'shop_website', with: 'https://www.hogehoge.com/'
        click_link '編集'
        select '3', from: "games_#{game.id}"
        click_button '更新する'
        expect(current_path).to eq(admin_shop_path(shop)), '店舗詳細ページへリダイレクトされていません'
        shop.reload
        expect(shop.name).to eq('hogehogeshop'), '店舗名の編集が適応されていません。'
        expect(shop.address).to eq('hogehogeaddress1-2-3'), '住所の編集が適応されていません。'
        expect(shop.phone_number).to eq('0123-4567-89'), '電話番号の編集が適応されていません。'
        expect(shop.website).to eq('https://www.hogehoge.com/'), 'WebサイトURLの編集が適応されていません。'
        expect(page.find('.badge-light')).to have_content('3'), 'ゲーム台数の編集が適応されていません。'
      end
    end
  end
end
