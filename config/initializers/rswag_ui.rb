begin
  if defined?(Rswag::Ui)
    Rswag::Ui.configure do |c|
      c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'API V1 Docs'
      # c.basic_auth_enabled = true
      # c.basic_auth_credentials 'username', 'password'
    end
  end
rescue NameError
  Rails.logger.info "rswag not available; skipping rswag_ui initializer"
end
