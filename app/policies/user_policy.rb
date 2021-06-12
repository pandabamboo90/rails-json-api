class UserPolicy < ApplicationPolicy
  # == Info ==
  # `user` is a performing subject,
  # `record` is a target object (model we want to update)

  def index?
    user.admin?
  end

  def show?
    # Only admin or owner can show
    user.admin? || (user.id == record.user_id)
  end

  def update?
    # Only admin or owner can update
    user.admin? || (user.id == record.user_id)
  end
end
