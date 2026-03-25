require "rails_helper"

RSpec.describe Api::V1::AttendanceEntriesController, type: :request do
  def auth_headers(user)
    token, = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    { "Authorization" => "Bearer #{token}" }
  end

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe "GET /api/v1/attendance_entries" do
    before do
      create_list(:attendance_entry, 2, user: user)
      create(:attendance_entry, user: other_user)
    end

    it "returns entries for the current user when authenticated" do
      get "/api/v1/attendance_entries", headers: auth_headers(user), as: :json

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body).to be_a(Hash)
      expect(body.fetch("entries").length).to eq(2)
    end

    it "returns unauthorized when no token provided" do
      get "/api/v1/attendance_entries", as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/v1/attendance_entries/:id" do
    let!(:entry) { create(:attendance_entry, user: user, student_name: "Old") }
    let!(:other_entry) { create(:attendance_entry, user: other_user) }

    it "updates an entry owned by the user" do
      patch "/api/v1/attendance_entries/#{entry.id}",
            params: { attendance_entry: { student_name: "New" } },
            headers: auth_headers(user),
            as: :json

      expect(response).to have_http_status(:ok)
      expect(entry.reload.student_name).to eq("New")
    end

    it "returns 404 when trying to update someone else's entry" do
      patch "/api/v1/attendance_entries/#{other_entry.id}",
            params: { attendance_entry: { student_name: "Hax" } },
            headers: auth_headers(user),
            as: :json

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/attendance_entries/:id" do
    let!(:entry) { create(:attendance_entry, user: user) }
    let!(:other_entry) { create(:attendance_entry, user: other_user) }

    it "destroys an owned entry" do
      delete "/api/v1/attendance_entries/#{entry.id}", headers: auth_headers(user), as: :json

      expect(response).to have_http_status(:no_content).or have_http_status(:ok)
      expect { entry.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "cannot destroy another user's entry" do
      delete "/api/v1/attendance_entries/#{other_entry.id}", headers: auth_headers(user), as: :json

      expect(response).to have_http_status(:not_found)
    end
  end
end

RSpec.describe "Api::V1::AttendanceEntries", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  it "creates an attendance entry for current_user" do
    expect do
      post api_v1_attendance_entries_path,
           params: {
             attendance_entry: {
               student_name: "Sam Houston",
               status: "present"
             }
           }, headers: auth_headers_for(user)
    end.to change { user.attendance_entries.count }.by(1)

    expect(response).to have_http_status(:created)
    entry = user.attendance_entries.last
    expect(entry.student_name).to eq("Sam Houston")
    expect(entry.status).to eq("present")
  end

  it "returns validation errors (array envelope) when invalid" do
    post api_v1_attendance_entries_path,
         params: { attendance_entry: { status: "present" } },
         headers: auth_headers_for(user)

    expect(response).to have_http_status(:unprocessable_entity)
    errors = response.parsed_body.fetch("errors")
    expect(errors).to be_an(Array)

    expect(errors).to include(
      a_hash_including(
        "field" => a_string_matching(/\Astudent_name|studentName\z/),
        "messages" => include("can't be blank")
      )
    )
  end
end
