# frozen_string_literal: true

# class
class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::ImplicitRender
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :send_bad_request

  protected

  def full_message_error(full_message, status)
    payload = {
      errors: { full_messages: [full_message.to_s] }
    }
    render json: payload, status: status
  end

  def send_bad_request(exception)
    payload = {
      errors: { full_messages: [exception.message.to_s] }
    }
    render json: payload, status: :bad_request
    Rails.logger.debug exception.message
  end

  def not_found(exception)
    payload = {
      errors: {
        full_messages: [
          "cannot find id[#{params[:id]}]"
        ]
      }
    }

    render json: payload, status: :not_found
    Rails.logger.debug exception
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
