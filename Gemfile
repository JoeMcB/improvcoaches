source "https://rubygems.org"
ruby "3.4.10"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "puma"
gem "pg", "~> 1.6"

gem "aws-sdk-s3", require: false

gem "bcrypt"
gem "bugsnag"
gem "dotenv-rails", groups: %i[development test]
gem "listen", groups: %i[development test]
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "turbo-rails"
gem "bigdecimal"


#Image Processing
gem "image_processing", "~> 2.0"
gem "ruby-vips", "~> 2.3"

gem "recaptcha", "~> 5.12", require: "recaptcha/rails"
gem "mutex_m"

#pagination
gem "will_paginate"

#recommendation
gem "recommendable"
gem "resque"

gem "validates_email_format_of"

gem "meta-tags", require: "meta_tags"

gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-rails_csrf_protection"
gem "newrelic_rpm"
gem "friendly_id"

group :development do
  gem "foreman", "~> 0.90"
  gem "pry"
  gem "pry-rails"
  gem "meta_request"
  gem "better_errors"
  gem "binding_of_caller"
  gem "yard"

  # Editor Gems
  gem "reek"
  gem "rubocop"
  gem "rubocop-rails", require: false
end

group :development, :test do
  gem "debug", platforms: :mri
end
