# frozen_string_literal: true

module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    # Override Devise's errors response
    include DeviseTokenAuthMethodsConcern

    # ----------------------------------------------------------------------------------------------------
    # Protected methods
    # ----------------------------------------------------------------------------------------------------

    protected

    def render_create_success
      render_resource(@resource)
    end

    def render_destroy_success
      render_success_message(message: "Logged out")
    end

    def render_create_error_bad_credentials
      render_error(401, I18n.t("devise_token_auth.sessions.bad_credentials"), app_error_code: 4010)
    end

    def render_create_error_account_locked
      render_error(401, I18n.t("devise.mailer.unlock_instructions.account_lock_msg"), app_error_code: 4012)
    end
  end
end
