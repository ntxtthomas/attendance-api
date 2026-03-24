module Api
  module V1
    class AttendanceEntriesController < ApplicationController
     before_action :authenticate_user!
     before_action :underscore_params!
     
      def index
        entries = current_user.attendance_entries.order(recorded_at: :desc).page(params[:page]).per(20)
        render json: entries, status: :ok
      end

      def create
        entry = AttendanceEntry.new(attendance_entry_params)
        entry.user = current_user
        if entry.save
          render json: entry, status: :created
        else
          render json: entry.errors, status: :unprocessable_entity
        end
      end

      def update
        entry = current_user.attendance_entries.where(id: params[:id]).first
        return head :not_found unless entry
        if entry.update(attendance_entry_params)
          render json: entry, status: :ok
        else
          render json: entry.errors, status: :unprocessable_entity
        end
      end

      def destroy
        entry = current_user.attendance_entries.where(id: params[:id]).first
        return head :not_found unless entry
        entry.destroy
        head :no_content
      end

      private

      def underscore_params!
        params.deep_transform_keys!(&:underscore)
      end

      def attendance_entry_params
        params.require(:attendance_entry).permit(:student_name, :status)
      end
    end
  end
end
