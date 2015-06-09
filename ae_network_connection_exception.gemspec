# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ae_network_connection_exception/version'

Gem::Specification.new do |spec|
  spec.name          = "ae_network_connection_exception"
  spec.version       = AeNetworkConnectionException::VERSION
  spec.authors       = ["Steven Boyd"]
  spec.email         = ["engineering@appfolio.com"]
  spec.summary       = "Provides sane exceptions for network failures"
  spec.description   = "A simple gem that will catch all manner of exceptions related to establishing a network connection and return a more generic error."
  spec.homepage      = "http://github.com/appfolio/ae_network_connection_exception"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
