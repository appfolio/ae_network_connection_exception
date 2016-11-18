require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'af_gems/gem_tasks'
require 'af_gems/appraisal'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/unit/**/*_test.rb'
  test.verbose = true
end

task :default => :test

namespace :test do
  AfGems::RubyAppraisalTask.new(:all, [ 'ruby-2.2.3', 'ruby-2.3.2' ])
end
