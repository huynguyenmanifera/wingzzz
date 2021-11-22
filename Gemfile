source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'dotenv-rails', groups: [:development, :test] # Autoload dotenv in Rails. Needs to be defined first.

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'aws-sdk-s3'# Official AWS Ruby gem for Amazon Simple Storage Service
gem 'draper' # Draper adds an object-oriented layer of presentation logic to your Rails apps.
gem 'slim-rails' # Provides the generator settings required for Rails 3+ to use Slim
gem 'devise', '~> 4.8' # Flexible authentication solution based on Warden
gem 'devise_invitable', '~> 2.0.0' # Invitable module for Devise
gem 'omniauth-facebook' # Facebook OAuth2 Strategy for OmniAuth. OmniAuth standardizes multi-provider authentication.
gem 'omniauth-rails_csrf_protection' #This gem provides a mitigation against CSRF on the request phase when using OmniAuth
gem 'omniauth-google-oauth2' # Google OAuth2 Strategy for OmniAuth.
gem 'ransack', '~> 2.3' # Enables the creation of both simple and advanced search forms
gem 'view_component' # View components for Rails
gem 'simple_form' # Simple Form aims to be as flexible as possible while helping you with powerful components to create your forms.
gem 'premailer-rails' # CSS styled emails without the hassle.
gem 'mollie-api-ruby' # Mollie API client for Ruby
gem 'aasm' # Library for adding finite state machines to Ruby classes.
gem "administrate" # Administrate is a library for Rails apps that automatically generates admin dashboards.
gem 'administrate-field-enum' # Adds missing enum field capability to administrate
gem 'carrierwave', '~> 2.1' # Provides a simple and extremely flexible way to upload files from Ruby application.
gem "fog-aws" # Fog AWS is used to support Amazon S3
gem 'rubyzip', '~> 2.3' # Library for reading and writing zip files.
gem 'i18n-js' # Small library to provide the Rails I18n translations on the JavaScript
gem 'i18n-tasks', '~> 0.9.31' # Manage translation and localization with static analysis, for Ruby i18n
gem 'http_accept_language' # Helps to detect the browser preferred language, as sent by the "Accept-Language" HTTP header.
gem 'tolk' # Tolk is a web interface for doing i18n translations packaged as an engine for Rails 4 applications
gem 'ahoy_matey' # Track visits and events in Ruby, JavaScript, and native apps
gem 'inline_svg', '~> 1.7'
gem 'appsignal'
gem 'faker', '~> 2.11'
gem 'factory_bot_rails'
gem 'rack-tracker', '~> 1.12', '>= 1.12.1'
gem 'cancancan', '~> 3.2.1' #Authorization library to restrict resource access for users
gem 'rolify', '~> 5.3.0' #Very simple Roles library without any authorization enforcement supporting scope on resource object.
gem 'acts-as-taggable-on', '~> 7.0'
gem 'administrate-field-acts_as_taggable'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.0.beta'
  gem 'letter_opener', '~> 1.7' # Preview email in the default browser instead of sending it
end

group :development do
  gem 'bullet' #help to kill N+1 queries and unused eager loading
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rubocop-rails'
  gem 'rails-erd' # Automatically generate an entity-relationship diagram (ERD) for your Rails models.
  gem 'railroady'
  gem 'html2slim' # Convert HTML to Slim templates. Because HTML sux and Slim rules. That's why.
  gem 'solargraph' # IDE tools for code completion, inline documentation, and static analysis
  gem 'ruby-debug-ide' # debug on VSCode
  gem 'debase' # debug on VSCode
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'cucumber-rails', require: false
    # database_cleaner is not mandatory, but highly recommended
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing' # Extracting `assigns` and `assert_template` from ActionDispatch.
  gem 'email_spec' # Easily test email in RSpec, Cucumber, and MiniTest
  gem 'webmock' # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'chronic' # Chronic is a natural language date/time parser written in pure Ruby
end
