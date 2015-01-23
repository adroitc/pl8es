source "https://rubygems.org"

ruby "2.1.1"
gem "rails", "4.0.2"

# Make sure gem is defined BEFORE any other gems that use environment variables
gem 'dotenv-rails', :groups => [:development, :test]

gem "bcrypt-ruby", :require => "bcrypt"


# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# –– json & jQuery

gem "jquery-rails"
gem "jquery-ui-rails"

gem 'client_side_validations', github: "DavyJonesLocker/client_side_validations", branch: "master"
gem "jsonify"
gem "yajl-ruby", require: "yajl"
gem "coffee-rails", "~> 4.0.0"
gem "jbuilder", "~> 1.2"

# –– database
gem 'pg'
gem 'hirb'

# –– images
gem "paperclip"
gem "aws-sdk"
gem "paperclip-dimension", :git => "git://github.com/mroem/paperclip-dimension.git"
gem "aws-ses", "~> 0.5.0", :require => 'aws/ses'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem "sdoc", require: false
end

gem "sass-rails", "~> 4.0.0"

gem "therubyracer", "0.11.3"
gem "less-rails"
gem "twitter-bootstrap-rails"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
  gem 'railroady'
end

group :production do
  # Use rails_12factor for heroku
  gem "rails_12factor"
end

# payment
gem "paypal-express"

# languages
gem "rename"
gem "globalize", "~> 4.0.1"

# location
gem "geokit-rails"

# RestClient
gem "rest-client"

# PDF
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
