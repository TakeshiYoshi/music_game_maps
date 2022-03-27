# frozen_string_literal: true

class Users::Profiles::FormComponent < ViewComponent::Base
  def initialize(user:, profile_form:)
    @user = user
    @profile_form = profile_form
  end

  private

  attr_reader :user, :profile_form
end
