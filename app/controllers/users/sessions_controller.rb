module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    before_action :set_json_format

    prepend_before_action only: :destroy do
      unless warden.authenticated?(:user)
        render json: { error: "Unauthorized", code: "unauthorized" }, status: :unauthorized
      end
    end

    def create
      credentials = sign_in_params
      resource = User.find_for_database_authentication(email: credentials[:email])

      if resource&.valid_password?(credentials[:password])
        sign_in(resource_name, resource)
        token, = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)
        render json: { token: token, user: { id: resource.id, email: resource.email } }, status: :ok
      else
        render json: { error: "Invalid Email or password.", code: "unauthorized" }, status: :unauthorized
      end
    end

    def destroy
      sign_out(current_user)
      head :no_content
    end

    private

    def set_json_format
      request.format = :json
    end

    def sign_in_params
      source = params[:user].presence || params

      {
        email: source[:email].to_s.strip.downcase,
        password: source[:password].to_s
      }
    end
  end
end
