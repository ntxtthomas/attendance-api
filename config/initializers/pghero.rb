# Protect PgHero routes with Rack HTTP Basic using PGHERO_USER/PGHERO_PASSWORD.
class PgHeroAuth
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path.start_with?("/pghero")
      auth = Rack::Auth::Basic::Request.new(env)
      if auth.provided? && auth.basic? && valid_credentials?(auth.credentials)
        @app.call(env)
      else
        return [401, { 'Content-Type' => 'text/plain', 'WWW-Authenticate' => 'Basic realm="PgHero"' }, ['Authorization Required']]
      end
    end
    @app.call(env)
  end

  private

  def valid_credentials?(creds)
    return false unless creds && creds.size == 2
    user, pass = creds
    ActiveSupport::SecurityUtils.secure_compare(user.to_s, ENV['PGHERO_USER'].to_s) &
      ActiveSupport::SecurityUtils.secure_compare(pass.to_s, ENV['PGHERO_PASSWORD'].to_s)
  rescue
    false
  end
end

Rails.application.config.middleware.insert_before 0, PgHeroAuth
