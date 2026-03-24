require 'rails_helper'

RSpec.describe "Api::V1::AttendanceEntries", type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user) }

  before { sign_in user }

  it "creates an attendance entry for current_user" do
    expect {
      post api_v1_attendance_entries_path, params: {
        attendance_entry: {
          student_name: "Sam Houston",
          status: "present"
        }
      }
    }.to change { user.attendance_entries.count }.by(1)

    expect(response).to have_http_status(:created)
    entry = user.attendance_entries.last
    expect(entry.student_name).to eq("Sam Houston")
    expect(entry.status).to eq("present")
  end

end
