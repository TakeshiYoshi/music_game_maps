require 'rails_helper'

RSpec.describe 'ユーザー', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  before { create_list(:game, 10) }
  
  describe 'ユーザー登録' do
    context '正しい情報を入力' do
      it 'ユーザーの新規登録が完了すること' do
        visit signup_path
        expect {
          fill_in 'userEmail', with: 'foo@bar.com'
          fill_in 'userPassword', with: 'Foobarhogehoge'
          fill_in 'userPasswordConfirmation', with: 'Foobarhogehoge'
          fill_in 'userNickname', with: 'FOOBAR'
          click_button '登録する'
        }.to change { User.count }.by(1), 'ユーザーのDB登録が出来ていません'
        expect(current_path).to eq(login_path), 'ログインページへリダイレクトされていません'
        expect(page.find('#flash-message')).to have_content('アカウント有効化用のメールを送信しました。'), 'フラッシュメッセージが表示されてません'
      end

      it 'PlayingGameモデルが作成されること' do
        visit signup_path
        expect {
          fill_in 'userEmail', with: 'foo@bar.com'
          fill_in 'userPassword', with: 'Foobarhogehoge'
          fill_in 'userPasswordConfirmation', with: 'Foobarhogehoge'
          fill_in 'userNickname', with: 'FOOBAR'
          page.first('label.glass-game-label').click
          click_button '登録する'
        }.to change { PlayingGame.count }.by(1), 'PlayingGameのDB登録が出来ていません'
      end
    end

    context '誤った情報を入力' do
      it 'ユーザーの新規作成がされないこと' do
        visit signup_path
        expect {
          fill_in 'userEmail', with: 'worng'
          page.first('label.glass-game-label').click
          click_button '登録する'
        }.to change { PlayingGame.count }.by(0), 'ユーザーがDB登録されています'
        expect(current_path).to eq(users_path), '別のページへリダイレクトされています'
      end
    end

    context '新規作成したユーザーの有効化ページへアクセス' do
      it 'ユーザーの有効化が完了すること' do
        visit signup_path
        expect {
          fill_in 'userEmail', with: 'foo@bar.com'
          fill_in 'userPassword', with: 'Foobarhogehoge'
          fill_in 'userPasswordConfirmation', with: 'Foobarhogehoge'
          fill_in 'userNickname', with: 'FOOBAR'
          click_button '登録する'
        }.to change { User.count }.by(1), 'ユーザーのDB登録が出来ていません'
        user = User.last
        visit activate_user_path(user.activation_token)
        expect(current_path).to eq(login_path), 'ログインページへリダイレクトされていません'
        expect(page.find('#flash-message')).to have_content('アカウントが有効化されました。'), 'フラッシュメッセージが表示されてません'
        expect(user.reload.activation_state).to eq('active'), 'ユーザーの有効化が完了していません'
      end
    end
  end

  describe 'ユーザープロフィール' do
    before do
      user.activate!
      login user
    end

    describe 'ユーザープロフィール編集' do
      context 'ログインしたアカウント以外の編集ページにアクセスする' do
        it '編集ページへのアクセスが出来ずにステータスが403エラーになること' do
          get edit_profile_user_path(another_user)
          expect(response.status).to eq(403), 'ステータスが403になっていません'
        end
      end

      context '正しい情報を入力' do
        it 'ユーザープロフィールの編集が成功すること(ニックネーム, 自己紹介)' do
          visit edit_profile_user_path(user)
          fill_in 'userNickname', with: 'hogefuga'
          fill_in 'userDescription', with: 'おはよう！こんにちは！こんばんは！'
          click_button '更新する'
          expect(current_path).to eq(user_path(user)), 'プロフィールページへリダイレクトされていません'
          expect(page.find('#flash-message')).to have_content('プロフィールを編集しました。'), 'フラッシュメッセージが表示されてません'
          expect(page).to have_content('hogefuga'), 'ニックネームの編集が適応されていません。'
          expect(page).to have_content('おはよう！こんにちは！こんばんは！'), '自己紹介の編集が適応されていません'
        end

        it 'ユーザープロフィールの編集が成功すること(プレー機種)' do
          visit edit_profile_user_path(user)
          expect {
            page.first('label.glass-game-label').click
            click_button '更新する'
          }.to change { PlayingGame.count }.by(1), 'PlayingGameのDB登録が出来ていません'
          expect(current_path).to eq(user_path(user)), 'プロフィールページへリダイレクトされていません'
          expect(page.find('#flash-message')).to have_content('プロフィールを編集しました。'), 'フラッシュメッセージが表示されてません'
          expect(page.all('label.glass-game-label').length).to eq(1), 'プレー機種の編集が適応されていません'
        end

        it 'ユーザープロフィールの編集が成功すること(アバター)' do
          visit edit_profile_user_path(user)
          attach_file 'avatar', 'spec/images/icon.png', make_visible: true
          click_button '更新する'
          expect(current_path).to eq(user_path(user)), 'プロフィールページへリダイレクトされていません'
          expect(page.find('#flash-message')).to have_content('プロフィールを編集しました。'), 'フラッシュメッセージが表示されてません'
        end
      end

      context '誤った情報を入力' do
        it 'ユーザープロフィールの編集が失敗すること' do
          visit edit_profile_user_path(user)
          fill_in 'userNickname', with: ''
          fill_in 'userDescription', with: 'a'*301
          click_button '更新する'
          expect(current_path).to eq(update_profile_user_path(user)), '他のページへリダイレクトされています'
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

  describe 'ユーザー設定編集' do
    before do
      user.activate!
      login user
    end

    context 'ログインしたアカウント以外の編集ページにアクセスする' do
      it '編集ページへのアクセスが出来ずにステータスが403エラーになること' do
        get edit_user_path(another_user)
        expect(response.status).to eq(403), 'ステータスが403になっていません'
      end
    end

    context '正しい情報を入力' do
      it 'ユーザー設定の編集が成功すること' do
        visit edit_user_path(user)
        fill_in 'userEmail', with: 'hogefuga@fuga.com'
        fill_in 'userPassword', with: 'Password1234'
        fill_in 'userPasswordConfirmation', with: 'Password1234'
        check 'user_anonymous'
        click_button '更新する'
        expect(current_path).to eq(edit_user_path(user)), 'ユーザー編集ページへリダイレクトされていません'
        expect(page.find('#flash-message')).to have_content('ユーザー設定の変更が完了しました。'), 'フラッシュメッセージが表示されてません'
        user.reload
        expect(user.email).to eq('hogefuga@fuga.com'), 'メールの編集が適応されていません。'
        expect(user.anonymous).to eq(true), '匿名設定の編集が適応されていません'
        # 再度ログインを行いパスワードが変更されたかチェックする
        page.find('label[for=nav-menu-check]').click
        sleep 1
        click_on 'ログアウト'
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'Password1234'
        click_button 'ログイン'
        expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
        expect(page.find('#flash-message')).to have_content('ログインに成功しました'), 'フラッシュメッセージが表示されてません'
      end
    end

    context '誤った情報を入力' do
      it 'ユーザー設定の編集が失敗すること' do
        visit edit_user_path(user)
        fill_in 'userEmail', with: ''
        fill_in 'userPassword', with: 'a'
        click_button '更新する'
        expect(current_path).to eq(user_path(user)), '他のページへリダイレクトされています'
        expect(page).to have_content('メールアドレスを入力してください'), 'メールアドレスに関するエラーメッセージが表示されていません'
        expect(page).to have_content('メールアドレスは不正な値です'), 'メールアドレスに関するエラーメッセージが表示されていません'
        expect(page).to have_content('パスワードは8文字以上で入力してください'), 'パスワードに関するエラーメッセージが表示されていません'
        expect(page).to have_content('パスワードは不正な値です'), 'パスワードに関するエラーメッセージが表示されていません'
        expect(page).to have_content('パスワード再入力とパスワードの入力が一致しません'), 'パスワードに関するエラーメッセージが表示されていません'
        expect(page).to have_content('パスワード再入力を入力してください'), 'パスワードに関するエラーメッセージが表示されていません'
      end
    end
  end
end
