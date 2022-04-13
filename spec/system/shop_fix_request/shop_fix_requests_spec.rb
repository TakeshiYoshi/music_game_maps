require 'rails_helper'

RSpec.describe "ShopFixRequest", type: :system do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop) }

  before { user.activate! }

  describe '店舗修正依頼' do
    context '未ログイン状態' do
      it '店舗修正依頼ボタンが表示されること' do
        visit shop_path(shop)
        expect(page).to have_content '店舗情報修正依頼'
      end
    end

    context 'ログイン状態' do
      before { login user }

      it '店舗修正依頼ボタンが表示されること' do
        visit shop_path(shop)
        expect(page).to have_content '店舗情報修正依頼'
      end

      context '正しい情報を入力' do
        it '修正依頼が完了すること' do
          visit new_shop_shop_fix_request_path(shop)

          check :shop_fix_request_not_exist
          fill_in :shop_fix_request_body, with: 'valid text'

          click_button '依頼する'

          expect(current_path).to eq shop_path(shop)
          expect(page.find('.flash-message')).to have_content('修正依頼ありがとうございます。')
        end
      end

      context '誤った情報を入力' do
        it 'エラーメッセージが表示されること' do
          visit new_shop_shop_fix_request_path(shop)

          check :shop_fix_request_not_exist
          fill_in :shop_fix_request_body, with: 'a' * 1001

          click_button '依頼する'

          expect(current_path).to eq shop_shop_fix_requests_path(shop)
          expect(page.find('.flash-message')).to have_content('依頼内容をご確認ください。')
          expect(page).to have_content('依頼内容詳細は1000文字以内で入力してください')
        end
      end
    end
  end
end