module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request

      def authenticate
        command = AuthenticateUser.call(params[:email], params[:password])

        if command.success?
          user_hash = UserSerializer.new(command.user).as_json
          render json: { auth_token: command.result, user: user_hash }, status: :ok
        else
          render json: command.errors, status: :unauthorized
        end
      end
    end
  end
end
