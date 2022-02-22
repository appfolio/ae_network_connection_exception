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
require 'minitest/autorun'
require 'minitest/reporters'
require 'rest-client'

MiniTest::Reporters.use! unless ENV['RM_INFO']
