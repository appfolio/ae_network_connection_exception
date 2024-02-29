# frozen_string_literal: true

require_relative 'lib/ae_network_connection_exception/version'

Gem::Specification.new do |spec|
  spec.name          = 'ae_network_connection_exception'
  spec.version       = AeNetworkConnectionException::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.author        = 'AppFolio'
  spec.email         = 'opensource@appfolio.com'
  spec.description   = 'Catch exceptions related to establishing a network connection and return a generic error.'
  spec.summary       = 'Provides sane exceptions for network failures.'
  spec.homepage      = 'https://github.com/appfolio/ae_network_connection_exception'
  spec.license       = 'MIT'
  spec.files         = Dir['**/*'].select { |f| f[%r{^(lib/|LICENSE.txt|.*gemspec)}] }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('< 3.4')
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
end
