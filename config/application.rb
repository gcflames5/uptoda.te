require File.expand_path('../boot', __FILE__)

#require 'rails/all'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UptodaTe
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
    # config.active_record.raise_in_transactional_callbacks = true

    Dropbox::API::Config.app_key = ENV["DROPBOX_APP_KEY"]
    Dropbox::API::Config.app_secret = ENV["DROPBOX_APP_SECRET"]
    Dropbox::API::Config.mode = ENV["DROPBOX_APP_TYPE"]


    #Paperclip::Attachment.default_options[:path] = ":rails_root/restricted/system/:rails_env/:class/:attachment/:id_partition/:filename"
    #Paperclip::Attachment.default_options[:url] = ":rails_root/restricted/system/:rails_env/:class/:attachment/:id_partition/:filename"
  end
end
