require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/unit/**/*_test.rb'
  test.verbose = true
end


