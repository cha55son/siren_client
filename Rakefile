require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
    t.rspec_opts = '--color'
  end
rescue LoadError
  # no rspec available
end
