module JsonApiErrorsHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :standard_error
    rescue_from ArgumentError,
                ActionController::ParameterMissing, with: :bad_request_error
    rescue_from JsonApiErrors::Unauthenticated, with: :unauthenticated_error
    rescue_from ActionPolicy::Unauthorized,
                ActionPolicy::UnauthorizedAction, with: :forbidden_access_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error
    rescue_from JsonApiErrors::MethodNotSupported, with: :method_not_supported_error
    rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique_error
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_errors
    rescue_from MiniMagick::Error, ImageProcessing::Error, with: :image_type_is_not_valid

    # ----------------------------------------------------------------------------------------------------
    # Private methods
    # ----------------------------------------------------------------------------------------------------

    private

    def bad_request_error(exception)
      http_code = 400

      render json: {
        errors: [
          error_hash(status: http_code,
                     title: Rack::Utils::HTTP_STATUS_CODES[http_code],
                     detail: exception.message)
        ]
      }, status: http_code
    end

    def unauthenticated_error(exception)
      render_json_api_error(http_code: 401, detail: exception.message, error_code: exception.dig("error_code"))
    end

    def forbidden_access_error(exception)
      if exception.respond_to?(:policy)
        render_json_api_error(http_code: 403, detail: exception.message, error_code: 4030)
      else
        render_json_api_error(http_code: 403, detail: exception.message, error_code: 4031)
      end
    end

    def record_not_found_error(exception)
      render_json_api_error(http_code: 404, detail: exception.message, error_code: exception.dig("error_code"))
    end

    def method_not_supported_error(exception)
      render_json_api_error(http_code: 405, detail: exception.message, error_code: exception.dig("error_code"))
    end

    def record_invalid_errors(exception)
      http_code = 422

      error_hashes = exception.record.errors.messages.map { |field, messages|
        messages.map do |message|
          detail = [field.to_s.titleize, message].join(" ")

          {
            status: http_code,
            source: { pointer: "/data/attributes/#{field}" },
            field: field,
            detail: detail
          }
        end
      }.flatten

      render json: { errors: error_hashes }, status: http_code
    end

    def image_type_is_not_valid
      render_json_api_error(http_code: 422, detail: "Image is invalid type", error_code: exception.dig("error_code"))
    end

    def record_not_unique_error(exception)
      render_json_api_error(http_code: 409, detail: exception.message, error_code: exception.dig("error_code"))
    end

    def standard_error(exception)
      logger.fatal(exception.full_message)
      render_json_api_error(http_code: 500, detail: exception.message, error_code: exception.dig("error_code"))
    end

    def render_json_api_error(http_code:, detail:, error_code: nil)
      render json: {
        errors: [
          error_hash(status: http_code,
                     title: Rack::Utils::HTTP_STATUS_CODES[http_code],
                     detail: detail,
                     error_code: error_code)
        ]
      }, status: http_code
    end

    def error_hash(status:, title:, detail:, error_code: nil)
      hash = {
        status: status,
        title: title,
        detail: detail
      }
      if error_code.present?
        hash[:code] = error_code
        hash[:code_detail] = APP_ERROR_CODES[error_code]
      end

      hash
    end
  end
end
