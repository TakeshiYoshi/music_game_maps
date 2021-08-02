require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
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
