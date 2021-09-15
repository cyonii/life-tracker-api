module API
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request

      def authenticate
        command = AuthenticateUser.call(params[:email], params[:password])

        if command.success?
          user_hash = {
            id: command.user.id,
            username: command.user.username,
            email: command.user.email
          }
          render json: { auth_token: command.result, user: user_hash }, status: :ok
        else
          render json: command.errors, status: :unauthorized
        end
      end
    end
  end
end
