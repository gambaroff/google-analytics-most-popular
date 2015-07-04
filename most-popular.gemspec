# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'most-popular/version'

Gem::Specification.new do |spec|
  spec.name          = "most-popular"
  spec.version       = MostPopular::VERSION
  spec.authors       = ["Stephania Gambaroff Thomas"]
  spec.email         = ["sthomas@marketplace.org"]

  spec.summary       = %q{Google Analytics Most popular}
  spec.description   = %q{Authorizes server to server account and returns X number of most viewed pages by path}
  spec.homepage      = "https://github.com/gambaroff/google-analytics-most-popular"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "google-api-client", "~> 0.8.6"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec-mocks", "~> 3.2"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.20"
  spec.add_development_dependency "dotenv", "~> 2.0"
end
