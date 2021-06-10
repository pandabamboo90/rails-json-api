# frozen_string_literal: true

module Overrides
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
    # Override Devise's errors response
    include DeviseTokenAuthMethodsConcern

    protected

    def render_validate_token_success
      render_resource(@resource)
    end

    def render_validate_token_error
      render_error(401, I18n.t("devise_token_auth.token_validations.invalid"))
    end
  end
end
