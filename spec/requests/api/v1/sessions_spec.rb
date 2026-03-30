require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, email: "test@example.com", password: "password") }

  def sign_in_user(user)
    post "/users/sign_in",
         params: { user: { email: user.email, password: user.password } },
         as: :json

    if response.headers["Authorization"].present?
      response.headers["Authorization"].split.last
    else
      response.parsed_body.fetch("token")
    end
  end

  describe "POST /users/sign_in" do
    it "returns a token on valid credentials" do
      token = sign_in_user(user)
      expect(token).to be_present
    end

    it "returns unauthorized on bad credentials" do
      post "/users/sign_in",
           params: { user: { email: user.email, password: "wrong" } },
           as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body).to include(
        "error" => a_kind_of(String),
        "code" => "unauthorized"
      )
    end

    it "allows an authenticated user to access protected endpoints" do
      token = sign_in_user(user)

      post "/api/v1/attendance_entries",
           params: { attendance_entry: { student_name: "Jane Doe", status: "present" } },
           headers: { "Authorization" => "Bearer #{token}" },
           as: :json

      expect(response).to have_http_status(:created).or have_http_status(:ok)
    end
  end

  describe "DELETE /users/sign_out" do
    it "returns no content and revokes the token" do
      token = sign_in_user(user)

      delete "/users/sign_out",
             headers: { "Authorization" => "Bearer #{token}" },
             as: :json

      expect(response).to have_http_status(:no_content)
    end

    it "prevents a revoked token from accessing protected endpoints" do
      token = sign_in_user(user)

      delete "/users/sign_out",
             headers: { "Authorization" => "Bearer #{token}" },
             as: :json

      get "/api/v1/me",
          headers: { "Authorization" => "Bearer #{token}" },
          as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns unauthorized when signing out without a token" do
      delete "/users/sign_out", as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body).to eq(
        "error" => "Unauthorized",
        "code" => "unauthorized"
      )
    end
  end
end
