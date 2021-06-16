module AuthorizeRolePermission
  include ActiveSupport::Concern

  def authorize_role_permission!
    return current_user.is_a?(Admin)

    unless current_user.permissions.exists?(controller_path: controller_path, action_name: action_name)
      raise ActionPolicy::UnauthorizedAction.new controller_path, action_name
    end
  end
end