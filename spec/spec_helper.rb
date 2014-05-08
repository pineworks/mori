ENV['RAILS_ENV'] ||= 'test'

PROJECT_ROOT = File.expand_path('../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, 'lib')

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

Bundler.require

require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'timecop'
require 'bcrypt'
require 'capybara/rspec'
require 'database_cleaner'
require 'helpers'

# Coveralls!
require 'coveralls'
Coveralls.wear!

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Helpers

  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.formatter = 'documentation'

  Timecop.safe_mode = true

  DatabaseCleaner.strategy = :transaction
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
