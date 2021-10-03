module API
  module V1
    class ActivitiesController < ApplicationController
      before_action :set_activity, only: [:show]

      # GET /activities
      def index
        @activities = Activity.all

        render json: @activities
      end

      # GET /activities/1
      def show
        render json: @activity
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_activity
        @activity = Activity.find(params[:id])
      end
    end
  end
end
