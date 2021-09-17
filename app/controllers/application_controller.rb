class ApplicationController < ActionController::API
  before_action :authenticate_request
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_rescue

  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeRequest.new(request.headers).user
    render json: { message: 'Not Authorized' }, status: :unauthorized unless @current_user
  end

  def record_not_found_rescue(exception)
    render json: { message: exception.message }, status: :not_found
  end
end
