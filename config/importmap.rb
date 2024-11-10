# Pin npm packages by running ./bin/importmap
# config/importmap.rb
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Add QR scanner dependencies
pin "qr-scanner", to: "https://ga.jspm.io/npm:qr-scanner@1.4.2/qr-scanner.min.js"