class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include JsonApiResponses
  include JsonApiErrorsHandlers
  include ActionPolicy::Controller
  include JSONAPI::Deserialization

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
end
