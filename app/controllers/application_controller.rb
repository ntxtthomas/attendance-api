class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Flash

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def render_not_found(exception)
    render json: { errors: [{ message: exception.message }] }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    record = exception.record
    errors = record.errors.map do |attr, msg|
      { field: attr.to_s.camelize(:lower), messages: [msg] }
    end
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: { errors: [{ message: exception.message }] }, status: :bad_request
  end
end
