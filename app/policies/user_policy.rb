class UserPolicy < ApplicationPolicy
  # == Info ==
  # `user` is a performing subject,
  # `record` is a target object (model we want to update)

  def index?
    admin?
  end

  def show?
    # Only admin or owner can show
    admin? || owner_updating_itself?
  end

  def update?
    # Only admin or owner can update
    admin? || owner_updating_itself?
  end
end
