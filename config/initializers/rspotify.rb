# frozen_string_literal: true
require 'rspotify'

RSpotify::Client.class_eval do
  def self.ensure_authenticated!
    unless @authenticated
      RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])
      @authenticated = true
    end
  end
end
