begin
  if defined?(Rswag::Api)
    Rswag::Api.configure do |c|
      c.openapi_root = Rails.root.join('swagger').to_s
      # c.swagger_filter = lambda { |swagger, env| swagger['host'] = env['HTTP_HOST'] }
    end
  end
rescue NameError
  Rails.logger.info "rswag not available; skipping rswag_api initializer"
end
