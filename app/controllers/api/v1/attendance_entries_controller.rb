module Api
  module V1
    class AttendanceEntriesController < BaseController
     before_action :authenticate_user!
     before_action :underscore_params!
     
      def index
        entries = current_user.attendance_entries.order(recorded_at: :desc)
        paginated = entries.page(params[:page]).per(params[:per_page] || 20)
        render json: paginated, meta: {
            pagination: {
              current_page: paginated.current_page,
              total_pages: paginated.total_pages,
              total_count: paginated.total_count
            }
          }, status: :ok
      end

      def create
        entry = AttendanceEntry.new(attendance_entry_params)
        entry.user = current_user
        if entry.save
          render json: entry, status: :created
        else
          render json: { errors: formatted_errors(entry) }, status: :unprocessable_entity
        end
      end

      def update
        entry = current_user.attendance_entries.find(params[:id])
        if entry.update(attendance_entry_params)
          render json: entry, status: :ok
        else
          render json: { errors: formatted_errors(entry) }, status: :unprocessable_entity
        end
      end

      def destroy
        entry = current_user.attendance_entries.find(params[:id])
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

      def formatted_errors(record)
        record.errors.messages.map do |field, msgs|
          { field: field.to_s.camelize(:lower), messages: msgs }
        end
      end

    end
  end
end
