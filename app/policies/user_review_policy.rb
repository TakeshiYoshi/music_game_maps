class UserReviewPolicy < ApplicationPolicy
  def destroy?
    user == record.user
  end
end
