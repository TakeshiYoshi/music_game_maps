# frozen_string_literal: true

module UserReviewDecorator
  def own?
    user == current_user
  end
end
