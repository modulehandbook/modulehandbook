# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin 'bootstrap', preload: true # @5.3.3
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
