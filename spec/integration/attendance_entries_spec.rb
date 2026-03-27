require 'swagger_helper'

RSpec.describe 'AttendanceEntries API', type: :request do
  path '/api/v1/attendance_entries' do
    get 'List attendance entries' do
      tags 'AttendanceEntries'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true, description: 'Bearer token'

      response '200', 'attendance entries' do
        schema type: :object,
               properties: {
                 entries: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       studentName: { type: :string },
                       status: { type: :string },
                       recordedAt: { type: :string, format: 'date-time' }
                     }
                   }
                 },
                 pagination: { type: :object }
               },
               required: ['entries']

        let(:user) { create(:user) }
        before do
          create_list(:attendance_entry, 2, user: user)
        end
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first}" }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end

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

  path '/api/v1/attendance_entries/{id}' do
    patch 'Update an attendance entry' do
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
