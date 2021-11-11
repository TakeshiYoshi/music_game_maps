require 'rails_helper'

RSpec.describe "ShopHistories", type: :system do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop, website: 'https://www.fuga.com') }
  let!(:game) { create(:game) }
  let!(:game_machine) { create(:game_machine, shop: shop, game: game) }

  before do
    user.activate!
  end

  describe '店舗履歴の投稿' do
    context '未ログイン状態' do
      it 'ユーザー登録ボタンが表示されること' do
        visit shop_path(shop)
        expect(page).to have_content('ユーザー登録してこの店舗の情報を編集する'), 'ユーザー登録ボタンが表示されていません'
      end
    end

    context '正しい情報を入力' do
      it '正常に投稿が完了すること' do
        login user
        visit new_shop_shop_history_path(shop)
        expect {
          fill_in 'shopName', with: 'hogehogefugafuga'
          fill_in 'shopWebsite', with: 'http://www.hoge.com'
          click_button '情報の更新を申請する'
        }.to change { ShopHistory.count }.by(1), '店舗履歴の投稿が完了していません'
      end

      it '投稿された履歴はstatusがdraftであること' do
        login user
        visit new_shop_shop_history_path(shop)
        fill_in 'shopWebsite', with: 'http://www.hoge.com'
        click_button '情報の更新を申請する'
        expect(ShopHistory.last.status).to eq('draft'), '投稿された履歴のstatusがdraftになっていません'
      end
    end

    context 'URLを誤ったフォーマットで入力' do
      it '投稿に失敗し「URLは不正な値です」とエラーが表示されること' do
        login user
        visit new_shop_shop_history_path(shop)
        fill_in 'shopWebsite', with: 'h222ttp://www.hoge.com'
        click_button '情報の更新を申請する'
        expect(page).to have_content('URLは不正な値です'), 'バリデーションエラーが表示されていません'
      end
    end

    context '何も変更せずに投稿する' do
      it '投稿に失敗し「URLは不正な値です」とエラーが表示されること' do
        login user
        visit new_shop_shop_history_path(shop)
        click_button '情報の更新を申請する'
        expect(page).to have_content('最低1つの情報を変更してください'), 'バリデーションエラーが表示されていません'
      end
    end
  end
end
