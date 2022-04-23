require 'rails_helper'

RSpec.describe '店舗検索機能', type: :system do
  # TODO: 検索機能実装後spec修正
  describe 'ヘッダー内検索フィールド' do
    context '店舗名で検索する' do
      let!(:shop_include_search_word_1) { create(:shop, name: 'タウトーステーション1号店', address: '東京都江戸川区南小岩1-1-1') }
      let!(:shop_include_search_word_2) { create(:shop, name: 'タウトーステーション2号店', address: '東京都江戸川区西葛西1-1-1') }
      let!(:another_shop) { create(:shop, name: '別店舗', address: '神奈川県藤沢市江ノ島1-1-1') }

      xit '入力された文字列が含まれている店舗のみ表示される(店舗名)' do
        visit root_path
        fill_in 'search-field', with: 'タウトーステーション'
        click_button 'search-button'
        expect(page).to have_content(shop_include_search_word_1.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).to have_content(shop_include_search_word_2.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).not_to have_content(another_shop.name), '入力された文字列が含まれていない店舗が表示されています'
      end

      xit '入力された文字列が含まれている店舗のみ表示される(住所)' do
        visit root_path
        fill_in 'search-field', with: '東京都'
        click_button 'search-button'
        expect(page).to have_content(shop_include_search_word_1.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).to have_content(shop_include_search_word_2.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).not_to have_content(another_shop.name), '入力された文字列が含まれていない店舗が表示されています'
      end
    end
  end

  describe '検索フィルター' do
    context 'ゲーム機種でフィルターをかける' do
      let!(:game) { create(:game, title: 'GAME BEAT') }
      let!(:another_game) { create(:game) }
      let!(:shop_include_filtered_game) { create(:shop) }
      let!(:another_shop) { create(:shop) }
      let!(:game_machine) { create(:game_machine, game: game, shop: shop_include_filtered_game) }

      it 'フィルターをかけた機種が設置されている店舗のみ検索結果に表示させる' do
        visit root_path
        click_on 'MAP MENU'
        within('.map-menu') do
          page.find(".m-mapForm__games-label", text: 'GAME BEAT').click
        end
        expect(page).to have_content(shop_include_filtered_game.name), 'フィルターをかけた機種が設置されている店舗が表示されていません'
        expect(page).not_to have_content(another_shop.name), 'フィルターをかけた機種が設置されていない店舗が表示されています'
      end
    end

    # TODO: 都道府県市区町村フィルタ実装後にspec修正
    context 'エリアでフィルターをかける' do
      let!(:prefecture) { create(:prefecture, name: 'Prefecture') }
      let!(:another_prefecture) { create(:prefecture, name: 'Another_Prefecture') }
      let!(:city) { create(:city, name: 'City', prefecture: prefecture) }
      let!(:another_city) { create(:city, name: 'Another_City', prefecture: prefecture) }
      let!(:shop_in_pref_city) { create(:shop, prefecture: prefecture, city: city) }
      let!(:shop_in_another_pref) { create(:shop, prefecture: another_prefecture) }
      let!(:shop_in_pref_another_city) { create(:shop, prefecture: prefecture, city: another_city) }

      xit 'フィルターをかけたエリアにある店舗のみ検索結果に表示される' do
        visit root_path
        # 都道府県のみフィルターをかける
        click_button 'filter-button'
        within('.modal') do
          select 'Prefecture', from: 'prefecture'
          click_button 'フィルター設定'
        end
        expect(page).to have_content(shop_in_pref_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).to have_content(shop_in_pref_another_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).not_to have_content(shop_in_another_pref.name), 'フィルターをかけたエリアにない店舗が表示されています'
        # 都道府県と市区町村のフィルターをかける
        click_button 'filter-button'
        within('.modal') do
          select 'Prefecture', from: 'prefecture'
          select 'City', from: 'city'
          click_button 'フィルター設定'
        end
        expect(page).to have_content(shop_in_pref_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).not_to have_content(shop_in_pref_another_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).not_to have_content(shop_in_another_pref.name), 'フィルターをかけたエリアにない店舗が表示されています'
      end
    end

    context '検索件数を20に変更' do
      before { create_list(:shop, 50) }

      it '1ページに表示される検索件数が20件になること' do
        visit root_path
        click_on 'MAP MENU'
        within('.map-menu') do
          select '20', from: 'filter_number_of_searches'
        end
        sleep 1
        expect(page.all('.m-shopCard').length).to eq(20), '1ページに表示される検索件数が20件になっていません'
      end
    end
  end
end
