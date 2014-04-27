require 'rails/generators/base'
require 'rails/generators/active_record'

module Mori
  module Generators
    class InstallGenerator < Rails::Generator::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_mori_initializer
        copy_file 'mori.rb', 'config/initializers/mori.rb'
      end
    end
  end
end
