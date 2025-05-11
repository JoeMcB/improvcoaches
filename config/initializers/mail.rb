ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'apikey',
  :password       => ENV['SENDGRID_API_KEY'],
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method ||= :smtp

# Set default URL options for mailers
Rails.application.config.action_mailer.default_url_options = {
  host: 'improvcoaches.com',
  protocol: 'https'
}
