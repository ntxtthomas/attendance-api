source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.4"

# Use sqlite3 as the database for Active Record
# gem "sqlite3", ">= 2.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use PostgreSQL as the database for Active Record [https://www.postgresql.org/]
gem 'pg', '~> 1.6', '>= 1.6.3'

# Use 
gem 'pghero', '~> 3.7'

# Use Redis for Action Cable in production [https://guides.rubyonrails.org/action_cable_overview.html#production-considerations]
gem 'redis', '~> 5.4', '>= 5.4.1'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

# Use Rack Attack for throttling and blocking abusive requests [https://github.com/kickstarter/rack-attack]
gem 'rack-attack', '~> 6.8'

# Use Active Model Serializers for JSON serialization [https://github.com/rails-api/active_model_serializers]
gem 'active_model_serializers', '~> 0.10.16'

# Use Pundit for authorization [https://github.com/varvet/pundit]
gem 'pundit', '~> 2.5', '>= 2.5.2'

# Use Devise for authentication [https://github.com/heartcombo/devise]
gem 'devise', '~> 5.0', '>= 5.0.3'

# Use Devise JWT for token-based authentication [https://github.com/waiting-for-dev/devise-jwt]
gem 'devise-jwt', '~> 0.13.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Use RuboCop for Ruby linting and style checking [https://github.com/rubocop/rubocop]
  gem "rubocop", "~> 1.85"
  
  # Ruby styling for Rails [https://github.com/rubocop/rubocop-rails]
  gem "rubocop-rails", "~> 2.34"
  
  # Use RSpec for testing [https://rspec.info/]
  gem "rspec-rails", "~> 8.0"

  # Use FactoryBot for fixtures replacement [https://github.com/thoughtbot/factory_bot]
  gem "factory_bot_rails"

  # Use Capybara for integration testing [https://teamcapybara.github.io/capybara/]
  gem "capybara"

  # Use Shoulda Matchers for RSpec [https://github.com/thoughtbot/shoulda-matchers]
  gem "shoulda-matchers", require: false

  # Use Timecop for time travel in tests [https://github.com/travisjeffery/timecop]
  gem "timecop"

  # Use Dotenv for environment variable management [https://github.com/bkeepers/dotenv]
  gem "dotenv-rails"

  # Use Pry for debugging in development [https://github.com/pry/pry]
  gem "pry"

  # Use rswagger for API documentation [https://github.com/rswag/rswag]
  gem "rswag"
  
  # Use Faker for generating fake data in tests [https://github.com/faker-ruby/faker]
  gem "faker"
end
