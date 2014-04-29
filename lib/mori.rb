require 'warden'
require 'mori/user'
require 'mori/controller'
require 'mori/configuration'
require 'mori/token'
require 'mori/engine'

module Mori
  def self.root
    File.expand_path('../..', __FILE__)
  end
end
