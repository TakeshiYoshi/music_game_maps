require 'rails_helper'

RSpec.describe 'Users::Profile', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  before do
    create_list(:game, 10)
    user.activate!
    login user
  end

  describe 'ユーザープロフィール編集' do
    context 'ログインしたアカウント以外の編集ページにアクセスする' do
      it '編集ページへのアクセスが出来ずにステータスが403エラーになること' do
        get edit_user_profile_path(another_user)
        expect(response.status).to eq(403), 'ステータスが403になっていません'
      end
    end

    context '正しい情報を入力' do
      it 'ユーザープロフィールの編集が成功すること(ニックネーム, 自己紹介)' do
        visit edit_user_profile_path(user)
        fill_in 'userNickname', with: 'hogefuga'
        fill_in 'userDescription', with: 'おはよう！こんにちは！こんばんは！'
        click_button '更新する'
        expect(current_path).to eq(user_path(user)), 'プロフィールページへリダイレクトされていません'
        expect(page.find('.flash-message')).to have_content('プロフィールを編集しました。'), 'フラッシュメッセージが表示されてません'
        expect(page).to have_content('hogefuga'), 'ニックネームの編集が適応されていません。'
        expect(page).to have_content('おはよう！こんにちは！こんばんは！'), '自己紹介の編集が適応されていません'
      end

      it 'ユーザープロフィールの編集が成功すること(プレー機種)' do
        visit edit_user_profile_path(user)
        expect {
          page.first('label.user-games-label').click
          click_button '更新する'
        }.to change { PlayingGame.count }.by(1), 'PlayingGameのDB登録が出来ていません'
        expect(current_path).to eq(user_path(user)), 'プロフィールページへリダイレクトされていません'
        expect(page.find('.flash-message')).to have_content('プロフィールを編集しました。'), 'フラッシュメッセージが表示されてません'
        expect(page.all('.m-badge__badge').length).to eq(1), 'プレー機種の編集が適応されていません'
      end

      it 'ユーザープロフィールの編集が成功すること(アバター)' do
        visit edit_user_profile_path(user)
        attach_file 'avatar', 'spec/images/icon.png', make_visible: true
        click_button '更新する'
        expect(current_path).to eq(user_path(user)), 'プロフィールページへリダイレクトされていません'
        expect(page.find('.flash-message')).to have_content('プロフィールを編集しました。'), 'フラッシュメッセージが表示されてません'
      end
    end

    context '誤った情報を入力' do
      it 'ユーザープロフィールの編集が失敗すること' do
        visit edit_user_profile_path(user)
        fill_in 'userNickname', with: ''
        fill_in 'userDescription', with: 'a'*301
        click_button '更新する'
        expect(current_path).to eq(user_profile_path(user)), '他のページへリダイレクトされています'
        expect(page).to have_content('ニックネームを入力してください'), 'ニックネームに関するエラーメッセージが表示されていません'
        expect(page).to have_content('自己紹介は300文字以内で入力してください'), '自己紹介に関するエラーメッセージが表示されていません'
      end
    end
  end

  describe 'ユーザープロフィール表示' do
    let!(:another_user) { create(:user) }
    before do
      another_user.activate!
      @user_reviews = create_list(:user_review, 10, user: user)
    end

    context 'プロフィールを表示する' do
      it 'ユーザー投稿に関する部分に投稿数が表示されること' do
        visit user_path(user)
        expect(page).to have_content('投稿した総件数：10件'), 'ユーザー投稿に関する部分に投稿数が表示されていません'
      end

      it 'ユーザー投稿は最新の5件が表示されていること' do
        visit user_path(user)
        4.upto(9) do |i|
          expect(page).to have_content(I18n.l(@user_reviews[i].created_at, format: :user_review)), 'ユーザー投稿は最新の5件が表示されていません'
        end
      end
    end

    context '匿名設定を有効にする' do
      before { user.update(anonymous: true) }

      context '自分自身のプロフィールを表示する' do
        it 'ユーザー投稿に関する部分が表示されること' do
          visit user_path(user)
          expect(page).to have_content('最近投稿した筐体情報'), 'ユーザー投稿に関する部分が表示されていません'
        end

        it '注意文「匿名設定が有効のためこの欄は他のユーザーには表示されません。」が表示されること' do
          visit user_path(user)
          expect(page).to have_content('匿名設定が有効のためこの欄は他のユーザーには表示されません。'), '注意文が表示されていません'
        end
      end

      context '他のユーザーで自分のプロフィールを表示' do
        it 'ユーザー投稿に関する部分が表示されないこと' do
          logout user
          login another_user
          visit user_path(user)
          expect(page).not_to have_content('最近投稿した筐体情報'), 'ユーザー投稿に関する部分が表示されています'
        end
      end
    end

    context '匿名設定を無効にする' do
      before { user.update(anonymous: false) }

      context '自分自身のプロフィールを表示する' do
        it '注意文「匿名設定が有効のためこの欄は他のユーザーには表示されません。」が表示されないこと' do
          visit user_path(user)
          expect(page).not_to have_content('匿名設定が有効のためこの欄は他のユーザーには表示されません。'), '注意文が表示されています'
        end
      end

      context '他のユーザーで自分のプロフィールを表示' do
        let!(:user_review) { create(:user_review, user: user) }

        it 'ユーザー投稿に関する部分が表示されること' do
          logout user
          login another_user
          visit user_path(user)
          expect(page).to have_content('最近投稿した筐体情報'), 'ユーザー投稿に関する部分が表示されていません'
        end
      end

      context '投稿数が0の場合' do
        it 'ユーザー投稿に関する部分が表示されないこと' do
          # 匿名設定と表示をあわせるために投稿数が0の場合は非表示にする
          user.user_reviews.destroy_all
          logout user
          login another_user
          visit user_path(user)
          expect(page).not_to have_content('最近投稿した筐体情報'), 'ユーザー投稿に関する部分が表示されています'
        end
      end
    end
  end
end
