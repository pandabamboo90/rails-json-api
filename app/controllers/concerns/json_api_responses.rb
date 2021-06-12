module JsonApiResponses
  include ActiveSupport::Concern

  def render_success_message(status: 200, message: "Success")
    render json: {
      meta: {
        message: message
      }
    }, status: status
  end
end
