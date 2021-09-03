# frozen_string_literal: true

module UserDecorator
  def nickname_in_review
    anonymous? ? t('defaults.anonymous') : nickname
  end

  def avatar_url_in_review
    anonymous? ? '/images/icon_default.png' : avatar.url
  end
end
