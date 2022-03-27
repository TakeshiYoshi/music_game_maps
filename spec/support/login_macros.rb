module LoginMacros
  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Foobarhogehoge'
    click_button 'ログイン'
  end

  def logout(user)
    visit login_path
    find('.m-userMenu__button').click
    click_on 'ログアウト'
    has_css?('.flash-message', text: 'ログアウトしました')
  end
end