# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module BlinkPhotoJockey
  class Application < Rails::Application
    config.load_defaults 7.2

    config.autoload_lib(ignore: %w[assets tasks])
    config.assets.precompile += %w( application.css application.js )
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.assets.initialize_on_precompile = false
  end
end
