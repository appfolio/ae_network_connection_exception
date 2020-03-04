# frozen_string_literal: true

require_relative 'lib/ae_network_connection_exception/version'

Gem::Specification.new do |spec|
  spec.name          = 'ae_network_connection_exception'
  spec.version       = AeNetworkConnectionException::VERSION
  spec.author        = 'Appfolio, Inc.'
  spec.email         = 'opensource@appfolio.com'
  spec.summary       = 'Provides sane exceptions for network failures'
  spec.description   = 'Catch exceptions related to establishing a network connection and return a generic error.'
  spec.homepage      = 'https://github.com/appfolio/ae_network_connection_exception'
  spec.license       = 'MIT'
  spec.files         = Dir['**/*'].select { |f| f[%r{^(lib/|test/|Rakefile$|README.md$|LICENSE.txt$|\w+\.*gemspec)}] }
  spec.require_paths = ['lib']

  spec.add_development_dependency('appraisal', '~> 2.2')
  spec.add_development_dependency('bundler', ['>= 1.7', '< 3.0'])
  spec.add_development_dependency('minitest', '~> 5.0')
  spec.add_development_dependency('minitest-reporters', '~> 1.4')
  spec.add_development_dependency('rake', '~> 10.0')
  spec.add_development_dependency('rest-client', '~> 2.0')
  spec.add_development_dependency('rubocop', '~> 0.80')
  spec.add_development_dependency('rubocop-minitest', '~> 0.6.2')
  spec.add_development_dependency('simplecov', '~> 0.17')
end
