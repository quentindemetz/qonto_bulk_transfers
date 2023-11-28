# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'bootsnap', require: false
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.2'
gem 'sqlite3', '~> 1.4'
gem 'tzinfo-data', platforms: %i[windows jruby]
group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rails'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
