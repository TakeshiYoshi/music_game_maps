class UserPolicy < ApplicationPolicy
  def edit?
    user == record
  end

  def update?
    user == record
  end

  def edit_profile?
    user == record
  end

  def update_profile?
    user == record
  end

  def destroy?
    user == record
  end
end
