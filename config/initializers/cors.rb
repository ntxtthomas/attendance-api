# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins = ENV["CORS_ALLOWED_ORIGINS"]&.split(",") || ["http://localhost:5174"]
    origins origins

    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: false,
      max_age: 600

    resource "/api-docs/*",
      headers: :any,
      methods: %i[get options head],
      credentials: false,
      max_age: 600
  end
end
