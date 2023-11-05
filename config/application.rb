require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PadlerzBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    Dir['./app/middlewares/*.rb'].sort.each do |file|
      require file
    end
    Dir['./config/constants/*.rb'].sort.each do |file|
      require file
    end
    config.autoload_paths += %W[#{config.root}/config/constants]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = AVAILABLE_LOCALES
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]
    config.i18n.fallbacks = Hash[(AVAILABLE_LOCALES - [:en]).map {|x| [x, :en]}]

    # config.active_job.queue_adapter = :sidekiq

    config.middleware.use RequestLogger
    config.middleware.use SetLanguage

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_caching = false
    config.action_mailer.default_url_options = {host: "temphost"}#{ host: Rails.application.credentials.smtp[:host] }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'smtp.gmail.com',
      user_name:            "tempname" ,#Rails.application.credentials.smtp[:email],
      password:             "temppass" ,#Rails.application.credentials.smtp[:password],
      authentication:       'plain',
      enable_starttls_auto: true,
      open_timeout:         5,
      read_timeout:         5
    }
  end
end
