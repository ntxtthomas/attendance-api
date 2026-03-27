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
  end
end
