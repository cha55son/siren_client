# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'siren_client/version'

Gem::Specification.new do |spec|
  spec.name          = "siren_client"
  spec.version       = SirenClient::VERSION
  spec.authors       = ["Chason Choate"]
  spec.email         = ["cha55son@gmail.com"]
  spec.summary       = %q{A client to traverse Siren APIs https://github.com/kevinswiber/siren}
  spec.description   = %q{SirenClient provides an ActiveRecord-like syntax to traverse Siren APIs.}
  spec.homepage      = "https://github.com/cha55son/siren_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.13"
  spec.add_dependency "activesupport", "~> 4"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
