# frozen_string_literal: true
require 'rspotify'

unless ENV['PRECOMPILE']
    begin
      RSpotify.authenticate(ENV.fetch('SPOTIFY_CLIENT_ID'), ENV.fetch('SPOTIFY_SECRET_ID'))
    rescue => e
      Rails.logger.error "Failed to initialize RSpotify: #{e.message}"
      # プリコンパイル時はエラーを無視
      nil if ENV['RAILS_ENV'] == 'production' && defined?(Rake) && Rake.application.top_level_tasks.include?('assets:precompile')
    end
  end
