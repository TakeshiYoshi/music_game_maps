module LoginMacros
  def login(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Foobarhogehoge'
    click_button 'ログイン'
  end

  def logout(user)
    visit login_path
    page.find('label[for=nav-menu-check]').click
    sleep 1
    click_on 'ログアウト'
  end
end