# frozen_string_literal: true

class Users::New::FormComponent < ViewComponent::Base
  def initialize(user_form:, provider:, nickname: nil)
    @user_form = user_form
    @provider = provider
    @nickname = nickname
  end

  private

  attr_reader :user_form, :provider, :nickname

  def form_url
    provider ? create_users_with_twitter_path(params.permit(:provider, :uid)) : users_path
  end
end
