class Rack::Attack
  # Use Redis in production for distributed counters (optional).
  # Initialize Redis-backed cache only when available and compatible; fall back to memory store.
  begin
    if ENV['REDIS_URL'] && defined?(ActiveSupport::Cache::RedisCacheStore)
      begin
        Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])
      rescue StandardError => e
        Rails.logger.info "RedisCacheStore unavailable (#{e.class}): #{e.message}; using MemoryStore"
        Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
      end
    else
      Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    end
  rescue StandardError => e
    # If anything unexpected happens during initializer (e.g. when running generators),
    # don't break Rails boot — fall back to memory store and log.
    warn "Rack::Attack initializer error: #{e.class} - #{e.message}"
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  # Throttle requests by IP: 100 reqs per minute
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    req.ip
  end

  # Example: throttle unsafe login attempts
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    req.path == '/login' && req.post? ? req.ip : nil
  end

  # Custom response for throttled requests
  # Use the new `throttled_responder` API to avoid deprecation warnings.
  self.throttled_responder = lambda do |env|
    [429, { 'Content-Type' => 'application/json' }, [{ error: 'Rate limit exceeded' }.to_json]]
  end
end

# Ensure middleware is used
Rails.application.config.middleware.use Rack::Attack
