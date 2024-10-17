require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module BlinkPhotoJockey
  class Application < Rails::Application

    config.load_defaults 7.2

    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
  end
end
