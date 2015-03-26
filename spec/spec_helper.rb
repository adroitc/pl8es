# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rails/test_help'
require 'rspec/rails'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
	
	config.color = true
	
	config.include Devise::TestHelpers, type: :controller
	config.include FactoryGirl::Syntax::Methods
	
	# include the routes
	config.include Rails.application.routes.url_helpers
	
	# include support stuff
	config.include Features::SessionHelpers, type: :feature
	
	config.before(:suite) do
		begin
			DatabaseCleaner.start
			FactoryGirl.lint
		ensure
			DatabaseCleaner.clean
		end
	end
	
	config.before(:each) do
		DatabaseCleaner.start
	end
	
	config.after(:each) do
		DatabaseCleaner.clean
	end
	
	config.infer_base_class_for_anonymous_controllers = false
	
	config.order = "random"
	config.include Capybara::DSL
end
