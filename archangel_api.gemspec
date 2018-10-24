# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "archangel_api/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "archangel_api"
  s.version     = ArchangelApi::VERSION
  s.authors     = ["Your Name"]
  s.homepage    = "https://github.com/archangel/archangel_api"
  s.summary     = "Summary of ArchangelApi."
  s.description = "Description of ArchangelApi."
  s.license     = "MIT"

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md"
  ]

  s.add_dependency "archangel", "< 1.0"
end
