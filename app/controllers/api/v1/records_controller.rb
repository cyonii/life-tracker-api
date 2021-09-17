module API
  module V1
    class RecordsController < ApplicationController
      before_action :verify_activity_existence
      before_action :set_record, only: %i[show update destroy]

      # GET /records
      def index
        @records = Record.where(activity_id: params[:activity_id], user_id: @current_user.id)

        if @records.length.zero? and Record.where(activity_id: params[:activity_id]).count.positive?
          return render json: { message: 'Forbidden' }, status: :forbidden
        end

        render json: @records
      end

      # GET /records/1
      def show
        render json: @record
      end

      # POST /records
      def create
        @record = Record.new(record_params)
        @record.user = @current_user

        if @record.save
          render json: @record, status: :created
        else
          render json: @record.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /records/1
      def update
        if @record.update(record_params)
          render json: @record
        else
          render json: @record.errors, status: :unprocessable_entity
        end
      end

      # DELETE /records/1
      def destroy
        @record.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_record
        @record = Record.find_by!(id: params[:id], activity_id: params[:activity_id])
        is_owner = @record && @record.user_id == @current_user.id

        render json: { message: 'Forbidden' }, status: :forbidden unless is_owner
      end

      # Only allow a list of trusted parameters through.
      def record_params
        params.require(:record).permit(:duration, :satisfaction, :date, :activity_id)
      end

      def verify_activity_existence
        # Return 404 response if activity is NotFound
        # even before attempting anything else
        Activity.find(params[:activity_id])
      end
    end
  end
end
