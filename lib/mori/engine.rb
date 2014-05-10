module Mori
  class Engine < ::Rails::Engine
    config.generators do |gen|
      gen.test_framework :rspec, :fixture => false
      gen.fixture_replacement :factory_girl, :dir => 'spec/factories'
      gen.assets false
      gen.helper false
    end

    initializer 'mori.filter' do |app|
      app.config.filter_parameters += [:password, :new_password, :new_password_confirmation]
    end

  end
end
