require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Financierav2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = 'Mexico City'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.assets.initialize_on_precompile = false
    config.autoload_paths << Rails.root.join('app/*')

    Humanize.configure do |config|
      config.default_locale = :en  # [:en, :es, :fr, :tr, :de, :id], default: :en
      config.decimals_as = :digits # [:digits, :number], default: :digits
    end

    Sentry.init do |config|
      config.dsn = ENV['SENTRY_DSN']
      config.breadcrumbs_logger = [:active_support_logger]
    
      # To activate performance monitoring, set one of these options.
      # We recommend adjusting the value in production:
      config.traces_sample_rate = 0.5
      # or
      config.traces_sampler = lambda do |context|
        true
      end
    end
  end
end
