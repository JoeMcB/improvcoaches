OmniAuth.config.logger = Rails.logger
#OmniAuth.config.on_failure = AuthController.action(:failure)
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], image_size: :large
end