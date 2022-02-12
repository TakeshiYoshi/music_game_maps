source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails', '~> 7.0', '>= 7.0.2.2'

# Security
gem 'gon'

# Database
gem 'mysql2'

# Application server
gem 'puma'

# Decorator
gem 'active_decorator'

# Assets
gem 'webpacker', '~> 4.0'
gem 'font-awesome-rails'

# UI/UX
gem 'rails-i18n'
gem 'slim-rails'
gem 'kaminari'
gem 'ransack'
gem 'carrierwave'
gem 'meta-tags'

# Turbolinks
gem 'jbuilder', '~> 2.7'
gem 'turbolinks', '~> 5'

# Authentication
gem 'sorcery'
gem 'pundit'

# Geolocation
gem 'geokit-rails'

# AWS
gem 'aws-sdk-rails', '~> 3'
gem 'fog-aws'

gem 'bootsnap', require: false
gem 'net-ssh'
gem 'net-smtp'
gem "sprockets-rails"
gem 'psych', '~> 3.1'

group :development, :test do
  # Debugger
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Code analyze
  gem 'rubocop'
  gem 'rubocop-rails'

  # Test
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'faker'

  # Email
  gem 'letter_opener_web'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
  gem 'launchy'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'web-console'
  gem 'html2slim'
end

group :development, :production do
  # scraping
  gem 'nokogiri'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
