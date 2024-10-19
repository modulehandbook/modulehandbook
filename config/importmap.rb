# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin 'jquery', preload: true # @3.6.1
pin 'popper.js', preload: true # @1.16.1
pin 'bootstrap', preload: true # @4.6.2
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
