source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'rails', '~> 6.0.3', '>= 6.0.3.7'

# Security
gem 'dotenv-rails'

# Database
gem 'mysql2', '>= 0.4.4'
gem 'nokogiri'

# Seeds
gem 'seed-fu'

# Application server
gem 'puma', '~> 4.1'

# Decorator
gem 'active_decorator'

# Assets
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'bootstrap', '~> 5.0'
gem 'font-awesome-rails'

# UI/UX
gem 'rails-i18n'
gem 'slim-rails'
gem 'html2slim'
gem 'kaminari'

# Turbolinks
gem 'jbuilder', '~> 2.7'
gem 'turbolinks', '~> 5'

# Authentication
gem 'sorcery'

# Time
gem 'chronic'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Debugger
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Code analyze
  gem 'rubocop', '~> 1.17.0'
  gem 'rubocop-rails', '~> 2.11'

  # Test
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
