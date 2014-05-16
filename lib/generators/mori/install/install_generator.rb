require 'rails/generators/base'
require 'rails/generators/active_record'

module Mori
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_mori_initializer
        copy_file 'mori.rb', 'config/initializers/mori.rb'
      end

      def include_in_application_controller
        inject_into(
          ApplicationController,
          'app/controllers/application_controller.rb',
          'include Mori::Controller'
        )
      end

      def create_or_modify_user_model
        if File.exists? 'app/models/user.rb'
          inject_into_file(
            'app/models/user.rb',
            "  include Mori::User\n\n",
            :after => "class User < ActiveRecord::Base\n"
          )
        else
          copy_file 'user.rb', 'app/models/user.rb'
        end
      end

      def generate_mori_migrations
        if users_table?
          create_add_columns_migration
        else
          copy_migration 'create_users.rb'
        end
      end

      def display_readme_in_terminal
        readme 'README'
      end

      private

      def users_table?
        ActiveRecord::Base.connection.table_exists?(:users)
      end

      def users_columns
        ActiveRecord::Base.connection.columns(:users).map(&:name)
      end

      def users_indexes
        ActiveRecord::Base.connection.indexes(:users).map(&:name)
      end

      def new_columns
        @new_columns ||= {
          :email => 't.string :email',
          :password => 't.string :password',
          :confirmation_token => 't.string :confirmation_token',
          :invitation_token => 't.string :invitation_token',
          :password_reset_token => 't.string :password_reset_token',
          :invitation_sent => 't.datetime :invitation_sent',
          :password_reset_sent => 't.datetime :password_reset_sent',
          :confirmed => 't.boolean :confirmed',
          :confirmation_sent => 't.datetime :confirmation_sent'
        }.reject { |column| users_columns.include?(column.to_s) }
      end

      def new_indexes
        @new_indexes ||= {
          :index_users_on_email => 'add_index :users, :email'
        }.reject { |index| users_indexes.include?(index.to_s) }
      end

      def create_add_columns_migration
        if migration_needed?
          config = {
            new_columns: new_columns,
            new_indexes: new_indexes
          }

          copy_migration('add_mori_to_users.rb', config)
        end
      end

      def migration_needed?
        new_columns.any? || new_indexes.any?
      end

      def copy_migration(migration_name, config = {})
        unless migration_exists?(migration_name)
          migration_template(
            "db/migrate/#{migration_name}",
            "db/migrate/#{migration_name}",
            config
          )
        end
      end

      def inject_into(class_name, file, text)
        if file_does_not_contain?(file, text)
          inject_into_class file, class_name, "  #{text}\n"
        end
      end

      def file_does_not_contain?(file, text)
        File.readlines(file).grep(/#{text}/).none?
      end

      def migration_exists?(name)
        existing_migrations.include?(name)
      end

      def existing_migrations
        @existing_migrations ||= Dir.glob("db/migrate/*.rb").map do |file|
          migration_name_without_timestamp(file)
        end
      end

      def migration_name_without_timestamp(file)
        file.sub(%r{^.*(db/migrate/)(?:\d+_)?}, '')
      end

      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end
    end
  end
end
