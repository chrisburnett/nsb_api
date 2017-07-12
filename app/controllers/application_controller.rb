class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end
end
