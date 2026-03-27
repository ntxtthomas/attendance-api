require 'swagger_helper'

RSpec.describe 'AttendanceEntries API', type: :request do
  path '/api/v1/attendance_entries' do
    post 'Create an attendance entry' do
      tags 'AttendanceEntries'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :attendance_entry, in: :body, schema: {
        type: :object,
        properties: {
          attendance_entry: {
            type: :object,
            properties: {
              student_name: { type: :string },
              status: { type: :string },
              recorded_at: { type: :string, format: 'date-time' }
            },
            required: ['student_name', 'status']
          }
        }
      }

      response '201', 'created' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }
        let(:attendance_entry) { { attendance_entry: { student_name: 'Ada Lovelace', status: 'present' } } }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        let(:attendance_entry) { { attendance_entry: { student_name: 'Ada Lovelace', status: 'present' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }
        let(:attendance_entry) { { attendance_entry: { student_name: '', status: '' } } }
        run_test!
      end
    end
  end
end
