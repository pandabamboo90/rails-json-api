# frozen_string_literal: true

module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController
    # Override Devise's errors response
    include DeviseTokenAuthMethodsConcern
    before_action :configure_permitted_parameters

    # ----------------------------------------------------------------------------------------------------
    # Protected methods
    # ----------------------------------------------------------------------------------------------------

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [data: [:password, :current_password, :password_confirmation]])
    end

    # Success responses
    def render_create_success
      render_success_message(message: I18n.t('devise_token_auth.passwords.sended', email: @email))
    end

    def render_update_success
      render_success_message(message: I18n.t('devise_token_auth.passwords.successfully_updated'))
    end

    # Error responses
    def render_create_error(errors)
      render_error(422, nil, @resource)
    end

    def render_create_error_missing_redirect_url
      render_error(400, I18n.t('devise_token_auth.passwords.missing_redirect_url'))
    end

    def render_error_not_allowed_redirect_url
      render_error(400, I18n.t('devise_token_auth.passwords.not_allowed_redirect_url', redirect_url: @redirect_url))
    end

    def render_update_error
      render_error(422, nil, @resource)
    end

    def render_update_error_missing_password
      @resource.errors.add(:password, :current_password, message: "is required")
      render_error(422, nil, @resource)
    end

    def render_update_error_password_not_required
      render_error(400, I18n.t('devise_token_auth.passwords.password_not_required', provider: @resource.provider.humanize))
    end


    private

    def resource_params
      # TODO: change reset password param
      params.permit(:email, :reset_password_token)
    end

    def password_resource_params
      params.permit(*params_for_resource(:account_update)).dig(:data)
    end
  end
end
