require 'rspotify'

unless defined?(@spotify_authenticated)
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])
  @spotify_authenticated = true
end