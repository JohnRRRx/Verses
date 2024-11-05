require 'rspotify'

if Rails.env.production? && ENV['RAILS_SKIP_SPOTIFY_AUTH'] != 'true'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])
end