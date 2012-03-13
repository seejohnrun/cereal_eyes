require 'rspec/core/rake_task'
require File.dirname(__FILE__) + '/lib/cereal_eyes/version'

task :build => :test do
  system "gem build cereal_eyes.gemspec"
end

task :release => :build do
  # tag and push
  system "git tag v#{CerealEyes::VERSION}"
  system "git push origin --tags"
  # push the gem
  system "gem push cereal_eyes-#{CerealEyes::VERSION}.gem"
end

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  fail_on_error = true # be explicit
end
