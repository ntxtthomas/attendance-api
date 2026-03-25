# Ensure Devise controllers running in API-only mode have a flash hash available.
# This is a minimal fallback to avoid NameError when middleware ordering or
# runtime reloads cause `ActionDispatch::Flash` to be unavailable for a short
# time in development.
Rails.application.config.to_prepare do
  if defined?(Devise::SessionsController)
    Devise::SessionsController.class_eval do
      include ActionController::Flash unless included_modules.include?(ActionController::Flash)

      before_action do
        request.env['action_dispatch.flash'] ||= ActionDispatch::Flash::FlashHash.new
      end
    end
  end
end
