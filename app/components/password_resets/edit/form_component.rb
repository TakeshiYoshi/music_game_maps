# frozen_string_literal: true

class PasswordResets::Edit::FormComponent < ViewComponent::Base
  def initialize(user:, token:)
    @user = user
    @token = token
  end

  private

  attr_reader :user, :token
end
