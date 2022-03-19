require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let!(:user) { create(:user) }
  before { user.activate! }

  describe 'ログイン' do
    context '正しいemailとpasswordを入力' do
      it '正常にログインが完了する' do
        login user
        expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
        expect(page.find('.flash-message')).to have_content('ログインに成功しました'), 'フラッシュメッセージが表示されてません'
      end
    end

    context '誤ったemailとpasswordを入力' do
      it 'エラーメッセージが表示されログインページにリダイレクトされる' do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'wrong'
        click_button 'ログイン'
        expect(current_path).to eq(user_sessions_path), '別のページへリダイレクトされています'
        expect(page.find('.flash-message')).to have_content('ログインに失敗しました'), 'フラッシュメッセージが表示されてません'
      end
    end

    context 'ログアウトリンクをクリックする' do
      it '正常にログアウトする' do
        login user
        page.find('label[for=nav-menu-check]').click
        sleep 1
        click_on 'ログアウト'
        expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
        expect(page.find('.flash-message')).to have_content('ログアウトしました'), 'フラッシュメッセージが表示されてません'
      end
    end

    context 'ログイン状態でログインページにアクセス' do
      it 'ルートページへリダイレクトすること' do
        login user
        visit login_path
        expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
      end
    end
  end

  describe 'ヘッダー' do
    context '未ログイン状態' do
      it 'ログインボタンが表示される' do
        visit root_path
        expect(page.all('a.login_icon').length).to eq(1), 'ログインボタンが表示されていません'
      end
    end

    context 'ログイン状態' do
      it 'ユーザーメニューが表示される' do
        login user
        visit root_path
        expect(page.all('label[for=nav-menu-check]').length).to eq(1), 'ユーザーメニューが表示されてません'
      end
    end
  end
end
