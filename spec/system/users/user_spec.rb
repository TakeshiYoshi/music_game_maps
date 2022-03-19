require 'rails_helper'

RSpec.describe 'Users', type: :system do
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
        expect(page.find('.flash-message')).to have_content('アカウント有効化用のメールを送信しました。'), 'フラッシュメッセージが表示されてません'
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

    context '既に登録されているemailを入力' do
      it 'ユーザーの新規作成がされないこと' do
        visit signup_path
        expect {
          fill_in 'userEmail', with: user.email
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
        expect(page.find('.flash-message')).to have_content('アカウントが有効化されました。'), 'フラッシュメッセージが表示されてません'
        expect(user.reload.activation_state).to eq('active'), 'ユーザーの有効化が完了していません'
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
        expect(page.find('.flash-message')).to have_content('ユーザー設定の変更が完了しました。'), 'フラッシュメッセージが表示されてません'
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
        expect(page.find('.flash-message')).to have_content('ログインに成功しました'), 'フラッシュメッセージが表示されてません'
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

    context '削除ボタンを押す' do
      it 'ユーザーが削除されること' do
        visit edit_user_path(user)
        expect {
          page.accept_confirm do
            click_on 'アカウントを削除する'
          end
          expect(current_path).to eq(root_path), 'トップページへリダイレクトされていません'
          expect(page.find('.flash-message')).to have_content('今までご利用頂きましてありがとうございました。'), 'フラッシュメッセージが表示されてません'
        }.to change { User.count }.by(-1), 'アカウントが削除されていません'
      end
    end
  end
end
