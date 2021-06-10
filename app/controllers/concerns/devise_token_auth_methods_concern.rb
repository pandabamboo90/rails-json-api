module DeviseTokenAuthMethodsConcern
  include ActiveSupport::Concern
  include JsonApiResponseConcern

  def render_resource(resource)
    serializer_options = {}

    if resource.is_a?(Admin)
      serializer_klass = AdminSerializer
    elsif resource.is_a?(User)
      serializer_klass = UserSerializer
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
end
