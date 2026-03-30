require "rails_helper"

RSpec.describe "Api::V1::Me", type: :request do
  let(:user) { create(:user, email: "me@example.com") }

  describe "GET /api/v1/me" do
    it "returns the authenticated user" do
      get "/api/v1/me", headers: auth_headers_for(user), as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(
        "user" => {
          "id" => user.id,
          "email" => "me@example.com"
        }
      )
    end

    it "returns unauthorized without a token" do
      get "/api/v1/me", as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end