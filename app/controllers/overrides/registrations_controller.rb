# frozen_string_literal: true

module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    # Override Devise's errors response
    include DeviseTokenAuthMethodsConcern

    # ----------------------------------------------------------------------------------------------------
    # Protected methods
    # ----------------------------------------------------------------------------------------------------

    protected

    # Success responses
    def render_create_success
      render_resource(@resource)
    end

    # Error responses
    def render_create_error
      render_error(422, nil, @resource)
    end

    def render_update_success
      render_resource(@resource)
    end

    def render_update_error
      render_error(422, nil, @resource)
    end

    def render_update_error_user_not_found
      render_error(404, I18n.t('devise_token_auth.registrations.user_not_found'))
    end

    def render_destroy_success
      render_success_message(status: 200, message: I18n.t('devise_token_auth.registrations.account_with_uid_destroyed', uid: @resource.uid))
    end

    def render_destroy_error
      render_error(404, I18n.t('devise_token_auth.registrations.account_to_destroy_not_found'))
    end
  end
end