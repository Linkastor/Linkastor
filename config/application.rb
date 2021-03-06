require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

#Remove warning on linux
require 'coffee_script'

module Linkastor
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

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    config.autoload_paths += %W(
        #{Rails.root.join('lib')}
        #{Rails.root.join('lib')}/validators
        #{Rails.root.join('lib')}/time
      ) 
    Dir[File.join(Rails.root, "lib", "extensions", "*.rb")].each {|l| require l }

    config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"
    
    config.api_session_expiration = 60*60*24*15 #15 days

    #lograge
    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      params = event.payload[:params].reject do |k|
        ['controller', 'action'].include? k
      end

      { "params" => params }
    end
    config.log_tags = [ lambda {|req| Time.now.to_s(:db) }, :remote_ip ]
  end
end
