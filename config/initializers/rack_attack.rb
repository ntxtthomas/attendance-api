class Rack::Attack
  # Use Redis in production for distributed counters (optional)
  if ENV['REDIS_URL']
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])
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
  self.throttled_response = lambda do |env|
    [429, { 'Content-Type' => 'application/json' }, [{ error: 'Rate limit exceeded' }.to_json]]
  end
end

# Ensure middleware is used
Rails.application.config.middleware.use Rack::Attack
