require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/users/sign_in' do
    post 'Sign in and receive JWT' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: ['user']
      }

      response '200', 'signed in' do
        schema type: :object,
               properties: {
                 token: { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string, format: :email }
                   },
                   required: %w[id email]
                 }
               },
               required: %w[token user]

        let(:existing_user) { create(:user, email: 'auth@example.com', password: 'password') }
        let(:user) { { user: { email: existing_user.email, password: 'password' } } }

        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string },
                 code: { type: :string, example: 'unauthorized' }
               },
               required: %w[error code]

        let(:user) { { user: { email: 'auth@example.com', password: 'wrong' } } }

        run_test!
      end
    end
  end

  path '/users/sign_out' do
    delete 'Revoke current JWT' do
      tags 'Auth'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: false, description: 'Bearer token'

      response '204', 'signed out' do
        let(:auth_user) { create(:user, email: 'logout@example.com', password: 'password') }
        let(:Authorization) do
          post '/users/sign_in', params: { user: { email: auth_user.email, password: 'password' } }, as: :json
          "Bearer #{response.parsed_body.fetch('token')}"
        end

        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string },
                 code: { type: :string, example: 'unauthorized' }
               },
               required: %w[error code]

        let(:Authorization) { nil }

        run_test!
      end
    end
  end

  path '/api/v1/me' do
    get 'Get current authenticated user' do
      tags 'Auth'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true, description: 'Bearer token'

      response '200', 'current user' do
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string, format: :email }
                   },
                   required: %w[id email]
                 }
               },
               required: ['user']

        let(:me_user) { create(:user, email: 'me@example.com') }
        let(:Authorization) { "Bearer #{Warden::JWTAuth::UserEncoder.new.call(me_user, :user, nil).first}" }

        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string },
                 code: { type: :string, example: 'unauthorized' }
               },
               required: %w[error code]

        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
