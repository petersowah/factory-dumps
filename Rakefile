require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

# Add Standard tasks
require "standard/rake"

task default: [:standard, :spec]
