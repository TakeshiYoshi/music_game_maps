require 'rails_helper'

RSpec.describe 'マップ内機能', type: :system do
  context 'マップで表示している周辺の店舗を検索する' do
    let!(:game) { create(:game, title: 'GAME BEAT') }
    let!(:far_away_shop) { create(:shop, name: '別店舗', lat: 90, lng: 90) }
    let!(:near_shop_1) { create(:shop, name: 'タウトーステーション1号店', lat: 30.0, lng: 150.0) }
    let!(:near_shop_2) { create(:shop, name: 'タウトーステーション2号店', lat: 30.1, lng: 150.1) }
    let!(:game_machine) { create(:game_machine, game: game, shop: near_shop_1) }

    it '検索中心から近い順番に店舗が表示される' do
      visit root_path
      # 擬似的に検索中心をlat: 30, lng: 150にする
      page.execute_script("document.getElementById('map-lat').value = '30.0000'");
      page.execute_script("document.getElementById('map-lng').value = '150.0000'");
      click_button 'search-near_shops_button'
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
      expect(page.all('.shop-card')[0]).to have_content(near_shop_1.name), '検索中心から近い店舗順に表示されていません'
      expect(page.all('.shop-card')[1]).to have_content(near_shop_2.name), '検索中心から近い店舗順に表示されていません'
      expect(page.all('.shop-card')[2]).to have_content(far_away_shop.name), '検索中心から近い店舗順に表示されていません'
    end

    it '周辺検索と機種フィルターが同時に機能すること' do
      visit root_path
      # 擬似的に検索中心をlat: 30, lng: 150にする
      page.execute_script("document.getElementById('map-lat').value = '30.0000'");
      page.execute_script("document.getElementById('map-lng').value = '150.0000'");
      click_button 'search-near_shops_button'
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
      # フィルターをかける
      click_button 'filter-button'
      within('.modal') do
        page.find(".game-label", text: 'GAME BEAT').click
        click_button 'フィルター設定'
      end
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
      expect(page).to have_content(near_shop_1.name), '周辺検索と機種フィルターが同時に機能していません'
      expect(page).not_to have_content(near_shop_2.name), '周辺検索と機種フィルターが同時に機能していません'
      expect(page).not_to have_content(far_away_shop.name), '周辺検索と機種フィルターが同時に機能していません'
    end

    it '検索後に検索クリアボタンが表示される' do
      visit root_path
      click_button 'search-near_shops_button'
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
      expect(page.all('a#clear-location-session').length).to eq(1), '検索後に検索クリアボタンが表示されていません'
    end

    it '検索クリアボタンをクリックすると周辺検索が解除される' do
      visit root_path
      # 擬似的に検索中心をlat: 30, lng: 150にする
      page.execute_script("document.getElementById('map-lat').value = '30.0000'");
      page.execute_script("document.getElementById('map-lng').value = '150.0000'");
      click_button 'search-near_shops_button'
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
      expect(page.all('.shop-card')[0]).to have_content(near_shop_1.name), '検索中心から近い店舗順に表示されていません'
      expect(page.all('.shop-card')[1]).to have_content(near_shop_2.name), '検索中心から近い店舗順に表示されていません'
      expect(page.all('.shop-card')[2]).to have_content(far_away_shop.name), '検索中心から近い店舗順に表示されていません'
      click_link 'clear-location-session'
      expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
      expect(page.all('.shop-card')[0]).to have_content(far_away_shop.name), '周辺検索が解除されていません'
      expect(page.all('.shop-card')[1]).to have_content(near_shop_1.name), '周辺検索が解除されていません'
      expect(page.all('.shop-card')[2]).to have_content(near_shop_2.name), '周辺検索が解除されていません'
    end

    it '検索後、「マップで表示している周囲の店舗を検索しました」とメッセージが表示される' do
      visit root_path
      click_button 'search-near_shops_button'
      expect(page.find('#map-flash-message')).to have_content('マップで表示している周囲の店舗を検索しました'), 'フラッシュメッセージが表示されてません'
    end

    it '検索クリア後、「周辺検索設定をクリアにしました」とメッセージが表示される' do
      visit root_path
      click_button 'search-near_shops_button'
      click_link 'clear-location-session'
      expect(page.find('#map-flash-message')).to have_content('周辺検索設定をクリアにしました'), 'フラッシュメッセージが表示されてません'
    end
  end

  context '現在位置表示ボタンをクリックする' do
    # RSpec上でgeolocation APIが動作しないためメッセージが表示されることのみ確認を行い
    # Vueが動作することのみテストしています。
    it '「現在位置情報を取得しています...」と表示される' do
      visit root_path
      click_button 'update-geo-button'
      expect(page.find('#map-flash-message')).to have_content('現在位置情報を取得しています...'), 'フラッシュメッセージが表示されてません'
    end
  end
end
