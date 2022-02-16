module CryptableUid
  extend ActiveSupport::Concern

  def encrypt_uid(uid)
    len = ActiveSupport::MessageEncryptor.key_len
    salt = Rails.application.credentials[:twitter][:uid_salt]
    secret = Rails.application.key_generator.generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(secret)
    crypt.encrypt_and_sign(uid)
  end

  def decrypt_uid(encrypted)
    len = ActiveSupport::MessageEncryptor.key_len
    salt = Rails.application.credentials[:twitter][:uid_salt]
    secret = Rails.application.key_generator.generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(secret)
    crypt.decrypt_and_verify(encrypted)
  end
end
