require 'rails_helper'

RSpec.describe "パスワードリセット", type: :system do
  let(:user) { create(:user) }

  it 'パスワードが変更できる' do
    visit new_password_reset_path
    fill_in 'email', with: user.email
    click_button 'パスワードを変更する'
    expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
    expect(page.find('#flash-message')).to have_content('入力されたアドレスに再発行用メールを送信しました。'), 'フラッシュメッセージが表示されてません'
    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in 'userPassword', with: 'FOObarhogehoge'
    fill_in 'userPasswordConfirmation', with: 'FOObarhogehoge'
    click_button 'パスワードを変更する'
    expect(page.find('#flash-message')).to have_content('パスワードの変更に成功しました。'), 'フラッシュメッセージが表示されてません'
    expect(current_path).to eq(root_path), 'ルートページへリダイレクトされていません'
  end
end
