source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '3.2.20'
gem 'unicorn'
gem 'unicorn-worker-killer'


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'aws-sdk', '~> 1.3.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'bcrypt-ruby', '~> 3.0.0'
gem 'dotenv-rails', :groups => [:development, :test]

#Image Processing
gem "paperclip", "~> 3.0"
gem 'font-awesome-rails'

gem "recaptcha", require: "recaptcha/rails"

# Deploy with Capistrano
# gem 'capistrano'


#pagination
gem 'will_paginate', '~> 3.0.0'

#recommendation
gem 'recommendable'
gem 'resque', "~> 1.22.0"
gem 'resque-loner'

gem 'validates_email_format_of'

gem 'meta-tags', :require => 'meta_tags'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'fb-channel-file'
gem 'google-analytics-rails'
gem 'newrelic_rpm'
gem 'friendly_id'
gem 'open_uri_redirections'

group :development do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'annotate'
end
