require 'swagger_helper'

RSpec.describe 'AttendanceEntries API', type: :request do
  path '/api/v1/attendance_entries/{id}' do
    put 'Update an attendance entry' do
      tags 'AttendanceEntries'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :attendance_entry, in: :body, schema: {
        type: :object,
        properties: {
          attendance_entry: {
            type: :object,
            properties: {
              student_name: { type: :string },
              status: { type: :string },
              recorded_at: { type: :string, format: 'date-time' }
            }
          }
        }
      }

      response '200', 'updated' do
        let(:user) { create(:user) }
        let(:entry) { create(:attendance_entry, user: user) }
        let(:id) { entry.id }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }
        let(:attendance_entry) { { attendance_entry: { student_name: 'Updated Name' } } }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:Authorization) { nil }
        let(:attendance_entry) { { attendance_entry: { student_name: 'Updated Name' } } }

        run_test!
      end

      response '404', 'not found' do
        let(:user) { create(:user) }
        let(:id) { 9999 }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }
        let(:attendance_entry) { { attendance_entry: { student_name: 'Updated Name' } } }

        run_test!
      end
    end
  end

  path '/api/v1/attendance_entries/{id}' do
    delete 'Delete an attendance entry' do
      tags 'AttendanceEntries'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :id, in: :path, type: :integer, required: true

      response '204', 'no content' do
        let(:user) { create(:user) }
        let(:entry) { create(:attendance_entry, user: user) }
        let(:id) { entry.id }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:id) { 1 }
        let(:Authorization) { nil }

        run_test!
      end

      response '404', 'not found' do
        let(:user) { create(:user) }
        let(:id) { 9999 }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }

        run_test!
      end
    end
  end
end
