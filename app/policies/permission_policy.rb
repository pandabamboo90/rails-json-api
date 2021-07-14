class PermissionPolicy < ApplicationPolicy
  # == Info ==
  # `user` is a performing subject,
  # `record` is a target object (model we want to update)

  def index?
    admin?
  end

  def show?
    # Only admin
    admin?
  end

  def update?
    # Only admin
    admin?
  end
end
