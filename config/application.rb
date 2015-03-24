require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'dotenv-rails'
Dotenv.load('credentials.env')

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Pl8es
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    # scan model subfolders, makes structuring models easy
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    
    config.assets.version = "1.01"
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{yml}')]
    config.i18n.fallbacks =[:en, :de, :fr]
		
		config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
			"<span class=\"field_with_errors\">#{html_tag}</span>".html_safe
		}
		
		console do
			require 'hirb'
			Hirb.enable
		end
  end
end
