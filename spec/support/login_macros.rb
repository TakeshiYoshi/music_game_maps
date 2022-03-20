module LoginMacros
  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Foobarhogehoge'
    click_button 'ログイン'
  end

  def logout(user)
    visit login_path
    find('label[for=nav-menu-check]').click
    sleep 1
    click_on 'ログアウト'
    has_css?('.flash-message', text: 'ログアウトしました')
  end
end