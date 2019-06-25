# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Capstone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    Mongoid.load!('./config/mongoid.yml')
    config.generators { |g| g.orm :active_record }
    # config.generators { |g| g.orm :mongoid }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #

    # config.middleware.insert_before 0, 'Rack:CORS' do
    # allow do
    # resource '*',
    # headers: :any,
    # expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
    # methods: %i[get post put delete options]
    # end
    # end

    config.generators do |g|
      g.test_framework :rspec,
                       model_specs: true,
                       routing_sepcs: false,
                       controller_specs: false,
                       helper_specs: false,
                       view_specs: false,
                       request_specs: true,
                       policy_specs: false,
                       feature_specs: true
    end

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
