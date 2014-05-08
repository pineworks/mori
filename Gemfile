source "https://rubygems.org"

gemspec

gem 'rspec-rails'
gem 'coveralls', require: false
gem 'sqlite3'
gem 'shoulda-matchers'
gem 'timecop'
gem 'capybara'
gem 'guard'
gem 'guard-rspec'
gem 'factory_girl'
gem 'factory_girl_rails'
gem 'faker'
gem 'selenium-webdriver'
gem 'database_cleaner'
gem 'jquery-rails'

rails_version = ENV["RAILS_VERSION"] || "default"

rails = case rails_version
when "master"
  {github: "rails/rails"}
when "default"
  ">= 3.2.0"
else
  "~> #{rails_version}"
end

gem "rails", rails
