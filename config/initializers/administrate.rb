# Administrate configuration

Rails.application.config.after_initialize do
  # Add custom field types
  require Rails.root.join("lib/administrate/field/password_reset")
end

# Add custom date/time formats
Time::DATE_FORMATS[:admin] = "%B %d, %Y at %I:%M %p"
Date::DATE_FORMATS[:admin] = "%B %d, %Y"