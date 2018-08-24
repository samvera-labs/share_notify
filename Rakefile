# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Run style checker"
RuboCop::RakeTask.new(:rubocop) do |task|
  # task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc "Run continuous integration tests"
task ci: [:rubocop, :spec]

task default: :ci
