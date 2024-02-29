# frozen_string_literal: true

require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

if ENV['WITH_COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    enable_coverage :branch
    add_filter %r{\A/test}
  end
end

require 'ae_network_connection_exception'
require 'debug'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'
require 'rest-client'
require 'http'

Mocha.configure do |config|
  config.stubbing_non_existent_method = :prevent
  config.strict_keyword_argument_matching = true
  config.stubbing_method_unnecessarily = :prevent
end

Minitest::Test.make_my_diffs_pretty!
Minitest::Reporters.use! unless ENV['RM_INFO']
