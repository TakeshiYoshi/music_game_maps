require 'rails_helper'

RSpec.describe '店舗検索機能', type: :system do
  describe 'ヘッダー内検索フィールド' do
    context '店舗名で検索する' do
      let!(:shop_include_search_word_1) { create(:shop, name: 'タウトーステーション1号店', address: '東京都江戸川区南小岩1-1-1') }
      let!(:shop_include_search_word_2) { create(:shop, name: 'タウトーステーション2号店', address: '東京都江戸川区西葛西1-1-1') }
      let!(:another_shop) { create(:shop, name: '別店舗', address: '神奈川県藤沢市江ノ島1-1-1') }

      it '入力された文字列が含まれている店舗のみ表示される(店舗名)' do
        visit root_path
        fill_in 'search-field', with: 'タウトーステーション'
        click_button 'search-button'
        expect(page).to have_content(shop_include_search_word_1.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).to have_content(shop_include_search_word_2.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).not_to have_content(another_shop.name), '入力された文字列が含まれていない店舗が表示されています'
      end

      it '入力された文字列が含まれている店舗のみ表示される(住所)' do
        visit root_path
        fill_in 'search-field', with: '東京都'
        click_button 'search-button'
        expect(page).to have_content(shop_include_search_word_1.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).to have_content(shop_include_search_word_2.name), '入力された文字列が含まれている店舗が表示されていません'
        expect(page).not_to have_content(another_shop.name), '入力された文字列が含まれていない店舗が表示されています'
      end
    end
  end

  describe 'ヘッダー内検索フィルター' do
    context 'ゲーム機種でフィルターをかける' do
      let!(:game) { create(:game, title: 'GAME BEAT') }
      let!(:another_game) { create(:game) }
      let!(:shop_include_filtered_game) { create(:shop) }
      let!(:another_shop) { create(:shop) }
      let!(:game_machine) { create(:game_machine, game: game, shop: shop_include_filtered_game) }

      it 'フィルターをかけた機種が設置されている店舗のみ検索結果に表示させる' do
        visit root_path
        click_button 'filter-button'
        within('.modal') do
          page.find(".game-label", text: 'GAME BEAT').click
          click_button 'フィルター設定'
        end
        click_button 'filter-button'
        expect(page).to have_content(shop_include_filtered_game.name), 'フィルターをかけた機種が設置されている店舗が表示されていません'
        expect(page).not_to have_content(another_shop.name), 'フィルターをかけた機種が設置されていない店舗が表示されています'
      end
    end

    context 'エリアでフィルターをかける' do
      let!(:shop_in_pref_city) { create(:shop, prefecture: Prefecture.find_by(name: '京都府'), city: City.find_by(name: '京都市')) }
      let!(:shop_in_another_pref) { create(:shop, prefecture: Prefecture.find_by(name: '大阪府')) }
      let!(:shop_in_pref_another_city) { create(:shop, prefecture: Prefecture.find_by(name: '京都府'), city: City.find_by(name: '宇治市')) }

      it 'フィルターをかけたエリアにある店舗のみ検索結果に表示される' do
        visit root_path
        # 都道府県のみフィルターをかける
        click_button 'filter-button'
        within('.modal') do
          select '京都府', from: 'prefecture'
          click_button 'フィルター設定'
        end
        expect(page).to have_content(shop_in_pref_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).to have_content(shop_in_pref_another_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).not_to have_content(shop_in_another_pref.name), 'フィルターをかけたエリアにない店舗が表示されています'
        # 都道府県と市区町村のフィルターをかける
        click_button 'filter-button'
        within('.modal') do
          select '京都府', from: 'prefecture'
          select '京都市', from: 'city'
          click_button 'フィルター設定'
        end
        expect(page).to have_content(shop_in_pref_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).not_to have_content(shop_in_pref_another_city.name), 'フィルターをかけたエリアにある店舗が表示されていません'
        expect(page).not_to have_content(shop_in_another_pref.name), 'フィルターをかけたエリアにない店舗が表示されています'
      end
    end
  end
end
