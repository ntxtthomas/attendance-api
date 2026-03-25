require 'rails_helper'

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
