# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
	config.expect_with(:rspec) { |c| c.syntax = :expect }
	config.color = true
	
	# include the routes
	config.include Rails.application.routes.url_helpers
	
	config.infer_base_class_for_anonymous_controllers = false
	
	# automatically recognise controller specs by the file location /controllers
	config.infer_spec_type_from_file_location!
	
	config.order = "random"
end
