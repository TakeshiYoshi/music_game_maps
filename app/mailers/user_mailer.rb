class UserMailer < ApplicationMailer
  def activation_needed_email(user)
    return if user.authentication.present?

    @user = user
    @url = activate_user_url(@user.activation_token)
    mail to: @user.email, subject: 'アカウントの有効化をして下さい'
  end

  def activation_success_email(user)
    return if user.authentication.present?

    @user = user
    @url = login_url
    mail to: @user.email, subject: 'あなたのアカウントが有効化されました！'
  end

  def reset_password_email(user)
    return if user.authentication.present?

    @user = user
    @url = edit_password_reset_url(@user.reset_password_token)
    mail to: @user.email, subject: 'パスワード再発行'
  end
end
