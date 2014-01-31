require "mori/configuration"
require "mori/engine"
require "mori/string"
require "mori/token"

module Mori
  def self.root
    File.expand_path('../..', __FILE__)
  end
end
