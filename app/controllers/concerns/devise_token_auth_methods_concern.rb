module DeviseTokenAuthMethodsConcern
  include ActiveSupport::Concern
  include JsonApiResponseConcern

  def render_resource(resource)
    serializer_options = {}

    if resource.is_a?(Admin)
      serializer_klass = AdminSerializer
    elsif resource.is_a?(BusinessProfile)
      serializer_klass = BusinessProfileSerializer
      serializer_options[:include] = [:address]
    elsif resource.is_a?(Staff)
      serializer_klass = StaffSerializer
      serializer_options[:include] = [:role, :location, :'location.d3_package']
    end

    raise StandardError, "Not a valid resource Class to serialize" if serializer_klass.blank?

    render json: serializer_klass.new(resource, serializer_options)
  end

  def render_error(status, message, resource = nil, app_error_code: nil)
    response = {
      errors: [
        {
          status: status,
          title: "Devise Token Auth error",
          detail: message
        }
      ]
    }
    if app_error_code.present?
      if APP_ERROR_CODES[app_error_code].blank?
        raise StandardError.new "APP_ERROR_CODES[#{app_error_code}] not existed."
      end

      ErrorSerializer.error_code(app_error_code)
    end

    case status
    when 400
      response[:errors] = ErrorSerializer.bad_request_error(message)
    when 401
      response[:errors] = ErrorSerializer.unauthenticated_error(message)
    when 404
      response[:errors] = ErrorSerializer.record_not_found_error(message)
    when 405
      response[:errors] = ErrorSerializer.method_not_supported_error(message)
    when 422
      response[:errors] = ErrorSerializer.record_invalid_errors(resource)
    else
      response
    end

    render json: response, status: status
  end

  def set_user_by_token(mapping = nil)
    # determine target authentication class
    rc = resource_class(mapping)

    # no default user defined
    return unless rc

    # gets the headers names, which was set in the initialize file
    uid_name = DeviseTokenAuth.headers_names[:uid]
    access_token_name = DeviseTokenAuth.headers_names[:'access-token']
    client_name = DeviseTokenAuth.headers_names[:client]

    # parse header for values necessary for authentication
    uid = request.headers[uid_name] || params[uid_name]
    @token ||= DeviseTokenAuth::TokenFactory.new
    @token.token ||= request.headers[access_token_name] || params[access_token_name]
    @token.client ||= request.headers[client_name] || params[client_name]

    # client isn't required, set to 'default' if absent
    @token.client ||= "default"

    # check for an existing user, authenticated via warden/devise, if enabled
    if DeviseTokenAuth.enable_standard_devise_support
      devise_warden_user = warden.user(rc.to_s.underscore.to_sym)
      if devise_warden_user && devise_warden_user.tokens[@token.client].nil?
        @used_auth_by_token = false
        @resource = devise_warden_user
        # REVIEW: The following line _should_ be safe to remove;
        #  the generated token does not get used anywhere.
        # @resource.create_new_auth_token
      end
    end

    # user has already been found and authenticated
    return @resource if @resource.present?

    # ensure we clear the client
    unless @token.present?
      @token.client = nil
      return
    end

    # mitigate timing attacks by finding by uid instead of auth token
    if rc.name == "Staff"
      # ---------------------------------
      # Customize the Devise flow here for Staff
      # ---------------------------------
      location = nil
      identity_token = params[:identity_token]

      if identity_token.present?
        location = Location::Base.find_by(d3_identity_token: identity_token)
      end

      user = uid && rc.dta_find_by(uid: uid, location_id: location.id) if location.present?
    else
      user = uid && rc.dta_find_by(uid: uid)
    end

    scope = rc.to_s.underscore.to_sym

    if user&.valid_token?(@token.token, @token.client)
      # sign_in with bypass: true will be deprecated in the next version of Devise
      if respond_to?(:bypass_sign_in) && DeviseTokenAuth.bypass_sign_in
        bypass_sign_in(user, scope: scope)
      else
        sign_in(scope, user, store: false, event: :fetch, bypass: DeviseTokenAuth.bypass_sign_in)
      end
      @resource = user
    else
      # zero all values previously set values
      @token.client = nil
      @resource = nil
    end
  end
end
