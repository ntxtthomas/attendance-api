require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, email: "test@example.com", password: "password") }

  it "returns a token and lets an authenticated user create attandance entries" do
    post "/users/sign_in",
         params: { user: { email: user.email, password: user.password } },
         as: :json

    token =
      if response.headers["Authorization"].present?
        response.headers["Authorization"].split.last
      else
        response.parsed_body.fetch("token")
      end

    expect(token).to be_present

    post "/api/v1/attendance_entries",
         params: { attendance_entry: { student_name: "Jane Doe", status: "present" } },
         headers: { "Authorization" => "Bearer #{token}" },
         as: :json

    expect(response).to have_http_status(:created).or have_http_status(:ok)
  end
end
