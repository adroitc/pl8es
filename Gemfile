source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.0.2"

# Use sqlite3 as the database for Active Record
#gem "sqlite3"

# Use SCSS for stylesheets
gem "sass-rails", "~> 4.0.0"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Use CoffeeScript for .js.coffee assets and views
gem "coffee-rails", "~> 4.0.0"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 1.2"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem "sdoc", require: false
end

group :development do
  gem "sqlite3"
  
  gem "better_errors"
  gem "binding_of_caller"
  
  gem "dotenv-rails"
end

group :production do
  #postgresql for heroku
  gem "pg"
  gem "rails_12factor"
end

# test
gem "block_helpers" # to remove

# json
gem "jsonify"

# encryption
gem "bcrypt-ruby", :require => "bcrypt"

# languages
gem "rename"
gem "globalize", "~> 4.0.1"
#gem "i18n-js"

# paperclip
gem "paperclip"
gem "aws-sdk"
gem "paperclip-dimension"
gem "aws-ses", "~> 0.5.0", :require => 'aws/ses'

gem "jquery-ui-rails"

group :assets do
  gem "therubyracer"
  gem "less-rails"
  gem "twitter-bootstrap-rails"
end

# Use ActiveModel has_secure_password
# gem "bcrypt-ruby", "~> 3.1.2"

# Use unicorn as the app server
# gem "unicorn"

# Use Capistrano for deployment
# gem "capistrano", group: :development

# Use debugger
# gem "debugger", group: [:development, :test]
