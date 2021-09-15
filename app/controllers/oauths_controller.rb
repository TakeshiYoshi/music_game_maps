class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    @user = login_from(provider)
    if @user
      redirect_to root_path, success: t('.success')
    else
      sorcery_fetch_user_hash(provider)
      redirect_to signup_with_twitter_path(provider: provider, uid: encrypt_uid(@user_hash[:uid]), nickname: @user_hash[:user_info]['name'])
    end
  end

  private

  def encrypt_uid(uid)
    len = ActiveSupport::MessageEncryptor.key_len
    salt = Rails.application.credentials[:twitter][:uid_salt]
    secret = Rails.application.key_generator.generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(secret)
    crypt.encrypt_and_sign(uid)
  end
end
