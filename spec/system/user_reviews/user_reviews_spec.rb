require 'rails_helper'

RSpec.describe "UserReviews", type: :system do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop) }
  let!(:game) { create(:game, title: 'GAME BEAT') }
  let!(:game_machine) { create(:game_machine, game: game, shop: shop) }

  before do
    user.activate!
  end

  describe 'ユーザー投稿の表示' do
    context '店舗に投稿がない場合' do
      it '「まだ投稿がありません。本店舗の情報提供お待ちしています。」とメッセージが表示されること' do
        visit shop_path(shop)
        expect(page).to have_content('まだ投稿がありません。本店舗の情報提供お待ちしています。'), '「まだ投稿がありません。本店舗の情報提供お待ちしています。」とメッセージが表示されていません'
      end
    end

    context 'Userモデルの匿名設定を有効にする' do
      it '投稿されたユーザーレビューに投稿主の名前が表示されないこと' do
        user.update(anonymous: true)
        login user
        visit shop_path(shop)
        page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
        within('#userReviewForm') do
          fill_in 'userReviewBody', with: '本文本文本文'
          click_button '投稿する'
        end
        within('#userReviews') do
          expect(page).not_to have_content(user.nickname), '投稿されたユーザーレビューに投稿主の名前が表示されています'
          expect(page).to have_content('匿名'), '投稿されたユーザーレビューに投稿主の名前が表示されています'
        end
      end
    end
  end

  describe 'ユーザーレビューの投稿' do
    context '未ログイン状態' do
      it 'ユーザー投稿ボタンが非表示になること' do
        visit shop_path(shop)
        expect(page).not_to have_content('この店舗の筐体情報を投稿'), 'ユーザー投稿ボタンが表示されています'
      end
    end

    context '正しい情報を入力' do
      it '正常に投稿が完了すること' do
        login user
        visit shop_path(shop)
        page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
        within('#userReviewForm') do
          fill_in 'userReviewBody', with: '本文本文本文'
          page.find(".glass-game-label", text: 'GAME BEAT').click
          sleep 0.5
          click_button '投稿する'
        end
        expect(current_path).to eq(shop_path(shop)), 'ショップページへリダイレクトされていません'
        expect(page.find('#flash-message')).to have_content('情報提供ありがとうございました！！'), 'フラッシュメッセージが表示されてません'
        within('#userReviews') do
          expect(page).to have_content(user.nickname), 'ユーザー投稿された内容が表示されていません(ユーザー名)'
          expect(page).to have_content('本文本文本文'), 'ユーザー投稿された内容が表示されていません(本文)'
        end
      end
    end

    context '本文を未入力' do
      it '投稿に失敗し「本文を入力してください」とエラーが表示されること' do
        login user
        visit shop_path(shop)
        page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
        within('#userReviewForm') do
          click_button '投稿する'
        end
        expect(current_path).to eq(shop_user_reviews_path(shop.id)), '別ページへリダイレクトされています'
        within('#userReviewForm') do
          expect(page).to have_content('本文を入力してください'), '投稿に失敗し「本文を入力してください」とエラーが表示されていません'
        end
      end
    end

    context '本文を1001文字入力' do
      it '投稿に失敗し「本文は1000文字以内で入力してください」とエラーが表示される' do
        login user
        visit shop_path(shop)
        page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
        within('#userReviewForm') do
          fill_in 'userReviewBody', with: 'a'*1001
          expect(page).to have_content('本文は1~1000文字で入力してください。'), 'バリデーションエラーが表示されていません'
          click_button '投稿する'
        end
        expect(current_path).to eq(shop_user_reviews_path(shop.id)), '別ページへリダイレクトされています'
        within('#userReviewForm') do
          expect(page).to have_content('本文は1000文字以内で入力してください'), '投稿に失敗し「本文は1000文字以内で入力してください」とエラーが表示されていません'
        end
      end
    end

    context '画像を添付する(4枚以下)' do
      it '投稿に成功し画像が表示されること' do
        login user
        visit shop_path(shop)
        page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
        within('#userReviewForm') do
          fill_in 'userReviewBody', with: '本文本文本文'
          attach_file 'userReviewImages', 'spec/images/icon.png', make_visible: true
          click_button '投稿する'
        end
        expect(current_path).to eq(shop_path(shop)), 'ショップページへリダイレクトされていません'
        expect(page.find('#flash-message')).to have_content('情報提供ありがとうございました！！'), 'フラッシュメッセージが表示されてません'
        within('#userReviews') do
          expect(page.all('.user-review-image').length).to eq(1), 'ユーザー投稿に画像が添付されていません'
        end
      end
    end

    context '画像を添付する(5枚以上)' do
      it '投稿に成功するが5枚目以降の画像は投稿されないこと' do
        login user
        visit shop_path(shop)
        page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
        within('#userReviewForm') do
          fill_in 'userReviewBody', with: '本文本文本文'
          attach_file 'userReviewImages', ['spec/images/icon.png', 'spec/images/icon.png', 'spec/images/icon.png', 'spec/images/icon.png', 'spec/images/icon.png'], make_visible: true
          expect(page).to have_content('添付画像の枚数を4枚以下にしてください。'), 'バリデーションエラーが表示されていません'
          click_button '投稿する'
        end
        expect(current_path).to eq(shop_path(shop)), 'ショップページへリダイレクトされていません'
        expect(page.find('#flash-message')).to have_content('情報提供ありがとうございました！！'), 'フラッシュメッセージが表示されてません'
        within('#userReviews') do
          expect(page.all('.user-review-image').length).to eq(4), 'ユーザー投稿に正しい枚数の画像が添付されていません'
        end
      end
    end
  end

  describe 'ユーザーレビューの削除' do
    let!(:another_user) { create(:user) }
    before do
      another_user.activate!
      login user
      visit shop_path(shop)
      page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
      within('#userReviewForm') do
        fill_in 'userReviewBody', with: '本文本文本文'
        click_button '投稿する'
      end
    end

    it 'ユーザーレビューの投稿主には削除ボタンが表示されること' do
      visit shop_path(shop)
      within('#userReviews') do
        expect(page).to have_content('削除する'), '削除ボタンが表示されていません'
      end
    end

    it 'ユーザーレビューの投稿主以外には削除ボタンが表示されないこと' do
      logout user
      login another_user
      visit shop_path(shop)
      within('#userReviews') do
        expect(page).not_to have_content('削除する'), '削除ボタンが表示されています'
      end
    end

    context 'ユーザーレビューの投稿主以外が削除リクエストを送信する' do
      it 'ユーザーレビューが削除されないこと' do
        logout user
        login another_user
        delete shop_user_review_path(shop, shop.user_reviews.last)
        visit shop_path(shop)
        within('#userReviews') do
          expect(page).to have_content(user.nickname), 'ユーザー投稿された内容が表示されていません(ユーザー名)'
          expect(page).to have_content('本文本文本文'), 'ユーザー投稿された内容が表示されていません(本文)'
        end
      end
    end

    context '削除ボタンを押す' do
      it 'ユーザーレビューが削除されること' do
        visit shop_path(shop)
        within('#userReviews') do
          page.accept_confirm do
            page.find(".btn-glass", text: '削除する').click
          end
        end
        expect(page).to have_content('まだ投稿がありません。本店舗の情報提供お待ちしています。'), 'ユーザーレビューが削除されていません'
      end
    end
  end

  describe 'ユーザー投稿プレビュー' do
    context 'ユーザーレビューの画像をクリックする' do
      it 'モーダルが開き画像が拡大表示されること' do
        login user
        visit shop_path(shop)
        page.find(".btn-glass", text: 'この店舗の筐体情報を投稿').click
        within('#userReviewForm') do
          fill_in 'userReviewBody', with: '本文本文本文'
          attach_file 'userReviewImages', ['spec/images/icon.png', 'spec/images/icon.png', 'spec/images/icon.png', 'spec/images/icon.png'], make_visible: true
          click_button '投稿する'
        end
        within('#userReviews') do
          page.all('.user-review-image').first.click
        end
        within('#userReviewModal') do
          expect(page).to have_content(user.nickname), 'モーダルにユーザー名が表示されていません'
          expect(page).to have_content('本文本文本文'), 'モーダルに本文が表示されていません'
        end
      end
    end
  end
end
