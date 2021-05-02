OmniAuth.config.logger = Rails.logger

#OmniAuth.config.on_failure = AuthController.action(:failure)
Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], auth_type: :https, image_size: :large, token_params: { parse: :json }
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
end