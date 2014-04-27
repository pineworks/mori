module Mori
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'mori.filter' do |app|
      app.config.filter_parameters += [:password, :new_password, :new_password_confirmation]
    end

  end
end
