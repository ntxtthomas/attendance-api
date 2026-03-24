Rails.application.config.after_initialize do
  # Defensive: remove duplicate Rack::Attack entries that may be added by other code/gems
  begin
    3.times { Rails.application.config.middleware.delete(Rack::Attack) rescue nil }
    # Ensure one instance is present
    Rails.application.config.middleware.use(Rack::Attack) unless Rails.application.config.middleware.any? { |m| m.klass == Rack::Attack rescue false }
  rescue StandardError => e
    Rails.logger.info "ensure_single_rack_attack failed: #{e.class} - #{e.message}"
  end
end
