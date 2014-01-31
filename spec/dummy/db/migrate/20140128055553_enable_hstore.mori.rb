# This migration comes from mori (originally 20140126052000)
class EnableHstore < ActiveRecord::Migration
  def self.up
    execute 'CREATE EXTENSION hstore'
  end

  def self.down
    execute 'DROP EXTENSION hstore'
  end
end
