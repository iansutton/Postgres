require 'rake'
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'

desc "Run all RSpec code examples"
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.rspec_opts = File.read("spec/spec.opts").chomp || ""
end

# Run through test suites
SPEC_SUITES = (Dir.entries('spec') - ['.', '..','fixtures']).select {|e| File.directory? "spec/#{e}" }
namespace :rspec do
  SPEC_SUITES.each do |suite|
    desc "Run #{suite} RSpec code examples"
    RSpec::Core::RakeTask.new(suite) do |t|
      t.pattern = "spec/#{suite}/**/*_spec.rb"
      t.rspec_opts = File.read("spec/spec.opts").chomp || ""
    end
  end
end

# Ignore these directories in tests
exclude_paths = [
  'spec/**/*.pp',
  'vendor/**/*.pp',
  'pkg/**/*.pp'
]

# Lint task
# You can troubleshoot errors and warnings @ http://puppet-lint.com/checks/
desc "Run lint tasks against module"
Rake::Task[:lint].clear # https://github.com/rodjek/puppet-lint/issues/331
PuppetLint::RakeTask.new :lint do |config|
  config.fail_on_warnings = true
  config.ignore_paths  = exclude_paths
  config.disable_checks = [
    '80chars',
  ]
  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

  # Only check autoloader if directory name is the same as the module
  if (File.expand_path(__FILE__).split('/')[-2] != 'speedrun')
    puts "WARNING: Autoload check disabled due to directory name mismatch"
    config.disable_checks.push('autoloader_layout')
  end
end

# Syntax task
PuppetSyntax.exclude_paths = exclude_paths

task :test => [:syntax, :lint, :rspec]
task :default => :test
