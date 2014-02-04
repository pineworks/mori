$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mori/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mori"
  s.version     = Mori::VERSION
  s.authors     = ["Aaron Miler"]
  s.email       = ["aaron@pineworks.com"]
  s.homepage    = "http://github.com/pineworks/mori"
  s.summary     = "TODO: Summary of Mori."
  s.description = "TODO: Description of Mori."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'bcrypt-ruby'
  s.add_dependency 'email_validator'
  s.add_dependency 'rails', '>= 3.0.0'
  s.add_dependency 'slim'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "pg"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'timecop'

end
