# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appdirect_integration/version'

Gem::Specification.new do |spec|
  spec.name          = "appdirect_integration"
  spec.version       = AppdirectIntegration::VERSION
  spec.authors       = ["Artem Golubev"]
  spec.email         = ["artem.golubev@appdirect.com"]

  spec.summary       = %q{Integration to AppDirect marketplace.}
  spec.description   = %q{Creates endpoints to integrate to callbacks from AppDirect marketplace to enable to sell subscriptions.}
  spec.homepage      = 'https://github.com/artgo/appdirect_integration'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.2.0"
  spec.add_dependency "oauth"
  spec.add_dependency "configurations"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "coveralls"
end
