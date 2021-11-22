require_relative 'boot'

require 'rails/all'
require 'view_component/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wingzzz
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en hu nl]
    config.i18n.fallbacks = [I18n.default_locale]

    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.generators.template_engine = :slim

    # ViewComponent:
    config.view_component.preview_path =
      "#{Rails.root}/spec/components/previews"

    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    # Load App helpers into administrate
    config.to_prepare do
      Administrate::ApplicationController.helper Wingzzz::Application.helpers
    end
  end

  def self.config
    Rails.application.config_for(:wingzzz)
  end
end
