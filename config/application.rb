require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Improvcoaches
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Propshaft configuration
    # Rails 7.1 uses Propshaft by default, no need to set pipeline explicitly
    
    # Set up asset paths
    config.assets.paths << Rails.root.join("app/assets/images")
    config.assets.paths << Rails.root.join("app/assets/fonts") if Dir.exist?(Rails.root.join("app/assets/fonts"))
    config.assets.paths << Rails.root.join("app/assets/javascripts")
    config.assets.paths << Rails.root.join("app/assets/builds")
    config.assets.paths << Rails.root.join("app/assets/stylesheets")
    
    # Set the asset prefix (default is /assets)
    config.assets.prefix = "/assets"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
