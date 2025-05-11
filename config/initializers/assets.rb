# Be sure to restart your server when you modify this file.

# Asset Pipeline Configuration - Rails 7

# Define asset paths
Rails.application.config.assets.paths = [
  Rails.root.join("app/assets/builds"),  # Contains compiled assets from esbuild/sass
  Rails.root.join("app/assets/stylesheets"),
  Rails.root.join("app/assets/images"),
]

# Add fonts directory if it exists
Rails.application.config.assets.paths << Rails.root.join("app/assets/fonts") if Dir.exist?(Rails.root.join("app/assets/fonts"))

# IMPORTANT: We explicitly do NOT include app/assets/javascripts directory
# All JavaScript is managed by esbuild and compiled to app/assets/builds

# Set asset prefix
Rails.application.config.assets.prefix = "/assets"
