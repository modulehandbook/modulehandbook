# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
