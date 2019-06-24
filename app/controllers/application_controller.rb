# frozen_string_literal: true

# class
class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

  protected

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
end
