source 'http://rubygems.org'
ruby '2.7.1'

gem 'rails', '5.2.8.1'
gem "sprockets", ">= 2.12.5"
gem "yard", ">= 0.9.11"
gem 'puma'


gem 'pg', '~> 1.0'
gem "aws-sdk-s3", require: false

gem 'jquery-rails'
gem 'jquery-ui-rails'


gem 'bcrypt-ruby'
gem 'bugsnag'
gem 'concurrent-ruby'
gem 'coffee-rails'
gem 'dotenv-rails', :groups => [:development, :test]
gem 'sass-rails'
gem 'uglifier'
gem 'mimemagic', '> 0.4'
gem 'bigdecimal', '1.4.2'


#Image Processing
gem 'paperclip', git: 'https://github.com/sd/paperclip', branch: 'remove-mimemagic'
gem 'font-awesome-rails'

gem "recaptcha", require: "recaptcha/rails"

#pagination
gem 'will_paginate'

#recommendation
gem 'recommendable'
gem 'resque'
gem 'resque-loner'

gem 'validates_email_format_of'

gem 'meta-tags', :require => 'meta_tags'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'fb-channel-file'
gem 'newrelic_rpm'
gem 'friendly_id'
gem 'open_uri_redirections'

group :development do
  gem 'annotate'
  gem 'byebug'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'meta_request'
  gem "better_errors"
  gem "binding_of_caller"

  # Editor Gems
  gem 'reek'
  gem 'rubocop'
end


group :production do
  gem 'rails_12factor'
end