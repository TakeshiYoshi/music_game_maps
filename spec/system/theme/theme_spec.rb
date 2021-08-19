require 'rails_helper'

RSpec.describe "テーマ変更", type: :system do
  let!(:user) { create(:user) }
  before { user.activate! }

  context 'ログイン状態' do
    it 'テーマ変更ボタンが表示されること' do
      login user
      visit root_path
      page.find('label[for=nav-menu-check]').click
      sleep 1
      expect(page.all('#editTheme').length).to eq(1), 'テーマ変更ボタンが表示されていません'
    end
  end

  context 'テーマ「dark」ボタンを押す' do
    it 'テーマ指定のカラーに背景色が変更されること' do
      login user
      visit root_path
      page.find('label[for=nav-menu-check]').click
      sleep 1
      page.find('div.dark').click
      sleep 1
      # 16進数            RGB
      # #1B474D          #370D62
      # rgb(27, 71, 77)  rgb(55, 13, 98)
      expect(page.find('body').native.css_value('background')).to have_content('rgb(27, 71, 77)'), 'テーマが変更されていません'
      expect(page.find('body').native.css_value('background')).to have_content('rgb(55, 13, 98)'), 'テーマが変更されていません'
      expect(user.reload.theme).to eq('dark'), 'テーマが変更されていません'
    end
  end

  context 'テーマ「dark」ボタンを押した後、ページ移動する' do
    it 'ページ移動後もテーマ「dark」が適応された状態のこと' do
      login user
      visit root_path
      page.find('label[for=nav-menu-check]').click
      sleep 1
      page.find('div.dark').click
      sleep 1
      visit root_path
      expect(page.find('body').native.css_value('background')).to have_content('rgb(27, 71, 77)'), 'テーマが変更されていません'
      expect(page.find('body').native.css_value('background')).to have_content('rgb(55, 13, 98)'), 'テーマが変更されていません'
      expect(user.reload.theme).to eq('dark'), 'テーマが変更されていません'
    end
  end
end
