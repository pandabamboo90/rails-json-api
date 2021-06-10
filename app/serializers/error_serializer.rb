module ErrorSerializer
  def self.error_code(code)
    @error_code = code
  end

  def self.error_hash(status, title, detail)
    hash = {
      status: status,
      title: title,
      detail: detail
    }
    if @error_code.present?
      hash[:code] = @error_code
      hash[:code_detail] = APP_ERROR_CODES[@error_code]
    end

    hash
  end

  def self.record_invalid_errors(record)
    record.errors.messages.map { |field, messages|
      messages.map do |message|
        detail = [field.to_s.titleize, message].join(" ")

        {
          status: 422,
          source: {pointer: "/data/attributes/#{field}"},
          field: field,
          detail: detail
        }
      end
    }.flatten
  end

  def self.bad_request_error(detail)
    [error_hash(400, "Bad request", detail)]
  end

  def self.unauthenticated_error(detail)
    [error_hash(401, "Unauthenticated", detail)]
  end

  def self.forbidden_access_error(detail)
    [error_hash(403, "Forbidden access", detail)]
  end

  def self.record_not_found_error(detail)
    [error_hash(404, "Record not found", detail)]
  end

  def self.method_not_supported_error(detail)
    [error_hash(405, "Method not supported", detail)]
  end

  def self.image_type_is_not_valid
    [error_hash(422, "Image is invalid type", "image_is_invalid_type")]
  end

  def self.record_not_unique_error(detail)
    [error_hash(409, "Record must be unique", detail)]
  end

  def self.standard_error(detail)
    [error_hash(500, "Internal server error", detail)]
  end
end
