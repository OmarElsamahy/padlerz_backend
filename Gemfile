source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.7"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# # For Dupeing Classes
# gem "amoeba"
#Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem "net-smtp", require: false
gem "net-imap", require: false
gem "net-pop", require: false

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Phone numbers
gem "global_phone"
gem "phonelib"
# Pagination
gem "kaminari"
# Serializer
gem "jsonapi-serializer"
# Active_job adapter
# gem "sidekiq", "< 7.0"
# devise for users
gem "devise"
# # for deployment
# gem "vlad"
# gem "vlad-git"

# for auth
gem "jwt"
# for cors
gem "rack-cors"
# Admin panel
gem "activeadmin"
gem "activeadmin_addons"
gem "arctic_admin"
gem "activeadmin-searchable_select"
gem "activeadmin_dynamic_fields"
gem "active_admin_datetimepicker"
gem "select2-rails", "~> 4.0"
gem "activeadmin_latlng"
gem "cancancan"
# for model ordering
gem "acts_as_list"
# For uploads
gem "aws-sdk"
gem "mobility", "~> 1.2.9"
gem "mobility-ransack"
gem "fcm"
gem "httparty"
# #geocode
# gem "geokit-rails"

# #currency validation
# gem "iso4217-validator"
# gem "geocoder"
# gem "auto_strip_attributes", "~> 2.6"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "annotate"
  gem 'rspec-rails'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Social Login
gem "firebase"

#facebook
gem "koala"
