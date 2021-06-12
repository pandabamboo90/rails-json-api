class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include JsonApiResponses
  include JsonApiErrorsHandlers
  include ActionPolicy::Controller
  include JSONAPI::Deserialization

  def index
    render json: {message: "API is online"}
  end
end
