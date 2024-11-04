# frozen_string_literal: true

pin 'application', preload: true
pin '@hotwired/turbo', to: '@hotwired--turbo.js' # @8.0.12
pin '@hotwired/turbo-rails', to: '@hotwired--turbo-rails.js' # @8.0.12
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@rails/actioncable/src', to: '@rails--actioncable--src.js' # @7.2.102
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin_all_from 'app/javascript', under: 'spotify_search'
