require 'warden'
require 'mori/user'
require 'mori/configuration'
require 'mori/engine'
require 'mori/string'
require 'mori/token'

module Mori
  module Controllers
    autoload :Helpers, 'mori/controllers/helpers'
  end
  def self.root
    File.expand_path('../..', __FILE__)
  end
end
