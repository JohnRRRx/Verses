require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false

  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_mailer.default_url_options = Settings.default_url_options.to_h
  config.action_cable.url = "wss://verses-take.fly.dev/cable"
  config.action_cable.allowed_request_origins = [ 'https://verses-take.fly.dev' ]

  config.action_controller.default_url_options = { host: 'verses-take.fly.dev' }

  config.public_file_server.enabled = true

  config.assets.css_compressor = nil
  config.assets.compile = true
  config.active_storage.service = :local

  config.force_ssl = true
  config.logger = ActiveSupport::Logger.new($stdout)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [:request_id]
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true

  config.action_mailer.default_url_options = Settings.default_url_options.to_h
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'verses-take.fly.dev',
    user_name:            ENV['GMAIL_USERNAME'],
    password:             ENV['GMAIL_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true 
  }
  config.active_support.report_deprecations = false

  config.active_record.dump_schema_after_migration = false
end
