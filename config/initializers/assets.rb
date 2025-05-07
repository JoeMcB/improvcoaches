# Be sure to restart your server when you modify this file.

# This initializer is for Propshaft configuration
# Propshaft's versioning strategy is different from Sprockets

# Configure the asset paths for Propshaft
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")
Rails.application.config.assets.paths << Rails.root.join("app/assets/stylesheets")
Rails.application.config.assets.paths << Rails.root.join("app/assets/images")
Rails.application.config.assets.paths << Rails.root.join("app/assets/fonts") if Dir.exist?(Rails.root.join("app/assets/fonts"))

# Set up custom Propshaft configurations 
Rails.application.config.assets.prefix = "/assets"
