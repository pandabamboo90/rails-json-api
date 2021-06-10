class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include JsonApiResponseConcern
  include ActionPolicy::Controller

  # before_action :set_api_error_code

  def index
    render json: {message: "API is online"}
  end

  def assign_model_attributes(model, model_attributes: nil)
    return model if model_attributes.blank?

    model.assign_attributes(model_attributes.except(:locked))

    if model_attributes.key?(:locked)
      if model_attributes[:locked]
        model.lock
      else
        model.unlock
      end
    end

    model
  end

  # def set_api_error_code
  #   ErrorSerializer.error_code(nil)
  # end

  # rescue_from StandardError do |exception|
  #   render json: { errors: ErrorSerializer.standard_error(exception.message) },
  #          status: 500
  # end

  rescue_from ArgumentError,
    ActionController::ParameterMissing do |exception|
    render json: {errors: ErrorSerializer.bad_request_error(exception.message)},
           status: 400
  end

  rescue_from ActionPolicy::Unauthorized do |exception|
    render json: {errors: ErrorSerializer.forbidden_access_error(exception.message)},
           status: 403
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {errors: ErrorSerializer.record_not_found_error(exception.message)},
           status: 404
  end

  rescue_from ActiveRecord::RecordNotUnique do |exception|
    render json: {errors: ErrorSerializer.record_not_unique_error(exception.message)},
           status: 409
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: {errors: ErrorSerializer.record_invalid_errors(exception.record)},
           status: 422
  end

  rescue_from MiniMagick::Error, ImageProcessing::Error do |e|
    render json: {errors: ErrorSerializer.image_type_is_not_valid},
           status: 422
  end
end
