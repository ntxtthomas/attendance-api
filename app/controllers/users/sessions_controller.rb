module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      token, = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)
      render json: { token: token, user: { id: resource.id, email: resource.email } }, status: :ok
    end
  end
end
