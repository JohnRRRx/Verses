# frozen_string_literal: true
require 'rspotify'

if defined?(Rake) && Rake.application.top_level_tasks.include?('assets:precompile')
  # プリコンパイル時は初期化をスキップ
  puts "Skipping RSpotify initialization during assets precompilation"
elsif Rails.env.production?
  begin
    RSpotify.authenticate(ENV.fetch('SPOTIFY_CLIENT_ID'), ENV.fetch('SPOTIFY_SECRET_ID'))
  rescue KeyError => e
    Rails.logger.error "Missing Spotify credentials: #{e.message}"
    raise unless ENV['PRECOMPILE']
  rescue => e
    Rails.logger.error "Failed to initialize RSpotify: #{e.message}"
    raise unless ENV['PRECOMPILE']
  end
else
  # development環境での初期化
  RSpotify.authenticate(ENV.fetch('SPOTIFY_CLIENT_ID', 'dummy'), ENV.fetch('SPOTIFY_SECRET_ID', 'dummy'))
end