# frozen_string_literal: true

class UserReviews::UserReviewComponent < ViewComponent::Base
  with_collection_parameter :user_review

  def initialize(user_review:, current_user:)
    @user_review = user_review
    @current_user = current_user
  end

  private

  attr_reader :user_review, :current_user
end
