# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from(ActiveRecord::RecordNotFound) do
    render status: :not_found
  end

  rescue_from(ActiveRecord::RecordInvalid) do
    render status: :bad_request
  end
end
