require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MusicGameMaps
  class Application < Rails::Application
    config.load_defaults 6.0

    config.generators.system_tests = nil

    config.generators do |g|
      g.skip_routes true
      g.assets false
      g.helper false

      g.test_framework :rspec,
        fixtures: false,
        view_spec: false,
        helper_spec: false,
        routing_spec: false,
        controller_spec: false,
        request_spec: false
    end

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}').to_s]

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    config.action_view.form_with_generates_remote_forms = false
  end
end
