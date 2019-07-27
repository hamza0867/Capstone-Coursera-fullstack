# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'coffee-rails', '~> 5.0'
gem 'httparty', '~> 0.17.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3'
gem 'mongoid'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'rspec-rails', '~> 3.8'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '~> 4.1'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 3.24'
  gem 'database_cleaner', '~> 1.7'
  gem 'factory_girl_rails', '~> 4.9'
  gem 'faker', '~> 1.9'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'simplecov', '~> 0.16.1', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'solargraph', '>=0.34.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-angular'
  gem 'rails-assets-angular-cookie'
  gem 'rails-assets-angular-material'
  gem 'rails-assets-angular-resource'
  gem 'rails-assets-angular-ui-router'
  gem 'rails-assets-ng-token-auth', '>=0.0.30'
end

gem 'devise_token_auth', '~> 1.1'
