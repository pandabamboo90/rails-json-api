# frozen_string_literal: true

module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController
    # Override Devise's errors response
    include DeviseTokenAuthMethodsConcern

    # ----------------------------------------------------------------------------------------------------
    # Protected methods
    # ----------------------------------------------------------------------------------------------------

    protected

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
  end
end
