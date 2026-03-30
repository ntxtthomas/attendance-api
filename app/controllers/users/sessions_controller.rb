module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    prepend_before_action only: :destroy do
      unless warden.authenticated?(:user)
        render json: { error: "Unauthorized", code: "unauthorized" }, status: :unauthorized
      end
    end

    def create
      resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      token, = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)
      render json: { token: token, user: { id: resource.id, email: resource.email } }, status: :ok
    end

    def destroy
      sign_out(current_user)
      head :no_content
    end
  end
end
