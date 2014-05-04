$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mori/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mori"
  s.version     = Mori::VERSION
  s.authors     = ["Aaron Miler"]
  s.email       = ["aaron@pineworks.io"]
  s.homepage    = "http://github.com/pineworks/mori"
  s.summary     = "Mori is a user authentication platform"
  s.description = "Mori is a lightweight module based authentication platform. Mori uses Warden for session management, and is intended to be easy to overwrite, and configurable."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'bcrypt-ruby'
  s.add_dependency 'email_validator'
  s.add_dependency 'warden'
  s.add_dependency 'rails', '>= 3.2.0'

end
