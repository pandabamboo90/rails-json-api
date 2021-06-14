class MemberAuthController < ApplicationController
  include DeviseTokenAuthMethodsConcern
  include AuthorizeRolePermission

  authorize :user, through: :current_user

  devise_token_auth_group :api_v1_member, contains: [:api_v1_admin, :api_v1_user]
  before_action :authenticate_api_v1_member!,
                :authorize_role_permission!

  def current_user
    current_api_v1_member
  end

  # This method is used to override the generated method by `devise_token_auth` gem  when invalid token is sent in the request,
  # to render error response using JSON API format
  # For example:
  #   User token was sent in headers but uid doesn't match or exist in our system
  def render_authenticate_error
    render_error(401, I18n.t("devise_token_auth.token_validations.invalid"), app_error_code: 4011)
  end
end
