require 'rspotify'

if ENV['RAILS_ENV'] != 'production' || ENV['PRECOMPILE'] != 'true'
  RSpotify::authenticate(
    ENV.fetch('SPOTIFY_CLIENT_ID'),
    ENV.fetch('SPOTIFY_SECRET_ID')
  )
end