require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Verses
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    config.secret_key_base = ENV.fetch('SECRET_KEY_BASE', nil)
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
  end
end
