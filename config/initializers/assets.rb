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

# Add Administrate gem assets to the path for Propshaft
if defined?(Administrate)
  administrate_path = Gem::Specification.find_by_name("administrate").gem_dir
  Rails.application.config.assets.paths << File.join(administrate_path, "app", "assets", "stylesheets")
  Rails.application.config.assets.paths << File.join(administrate_path, "app", "assets", "javascripts")
  
  # Add selectize-rails assets
  if defined?(Selectize)
    selectize_path = Gem::Specification.find_by_name("selectize-rails").gem_dir
    Rails.application.config.assets.paths << File.join(selectize_path, "vendor", "assets", "stylesheets")
    Rails.application.config.assets.paths << File.join(selectize_path, "vendor", "assets", "javascripts")
  end
end

# IMPORTANT: We explicitly do NOT include app/assets/javascripts directory
# All JavaScript is managed by esbuild and compiled to app/assets/builds

# Set asset prefix
Rails.application.config.assets.prefix = "/assets"
