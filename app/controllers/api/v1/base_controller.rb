module Api
  module V1
    class BaseController < ApplicationController
      before_action :set_default_format

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      private

      def set_default_format
        request.format = :json
      end

      def render_not_found(_exception = nil)
        render json: { error: "Not Found" }, status: :not_found
      end
    end
  end
end
