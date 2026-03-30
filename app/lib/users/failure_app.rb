module Users
  class FailureApp < Devise::FailureApp
    def respond
      if json_request?
        json_error_response
      else
        super
      end
    end

    private

    def json_request?
      request.format.json? || request.path.start_with?("/api/", "/users/")
    end

    def json_error_response
      self.status = :unauthorized
      self.content_type = "application/json"
      self.response_body = {
        error: i18n_message || "Unauthorized",
        code: "unauthorized"
      }.to_json
    end
  end
end
