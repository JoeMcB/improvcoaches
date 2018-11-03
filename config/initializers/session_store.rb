# Be sure to restart your server when you modify this file.

if Rails.env.development?
	domain = "localhost"
else
	domain = "improvcoaches.com"
end


Improvcoaches::Application.config.session_store :cookie_store, key: '_improvcoaches_session', domain: domain

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Improvcoaches::Application.config.session_store :active_record_store
