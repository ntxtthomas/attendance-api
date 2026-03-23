Rails.application.routes.draw do
  devise_for :users

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Serve a static swagger yaml file for rswag UI (handles GET and HEAD)
  get '/api-docs/v1/swagger.yaml', to: proc { |env|
    path = Rails.root.join('swagger', 'v1', 'swagger.yaml')
    if File.exist?(path)
      body = File.read(path)
      [200, { 'Content-Type' => 'text/yaml' }, [body]]
    else
      [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
    end
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "/index"
    # Mount PgHero in development only. Protect with HTTP Basic using PGHERO_USER/PGHERO_PASSWORD.
    if Rails.env.development?
        # PgHero removed — no local mount. See README or Gemfile comments.
    end

end

