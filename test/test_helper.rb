ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  setup do
    host! "www.improvcoaches.com"
  end

  def sign_in_as(user, password: "secret")
    post login_path, params: { email: user.email, password: password }
    assert_redirected_to root_path
  end
end

class ActionMailer::TestCase
  include Rails.application.routes.url_helpers
end
