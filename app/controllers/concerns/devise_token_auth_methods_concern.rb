module DeviseTokenAuthMethodsConcern
  include ActiveSupport::Concern
  include JsonApiErrors

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

    case status
    when 400
      raise ArgumentError.new message
    when 401
      raise Unauthenticated.new message, app_error_code
    when 404
      raise ActiveRecord::RecordNotFound.new message
    when 405
      raise MethodNotSupported.new message
    when 422
      raise ActiveRecord::RecordInvalid.new resource
    else
      render json: response, status: status
    end
  end
end
