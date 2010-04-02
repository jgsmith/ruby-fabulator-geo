$: << File.expand_path(File.dirname(__FILE__))+'/lib'
$: << File.expand_path(File.dirname(__FILE__))+'/../fabulator/lib'

require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require 'fabulator'
require './lib/fabulator/geo'

Hoe.plugin :newgem
# Hoe.plugin :website
Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'fabulator-xml' do
  self.version = Fabulator::Geo::VERSION::STRING
  self.developer 'James Smith', 'jgsmith@tamu.edu'
  self.rubyforge_name       = self.name # TODO this is default value
  # self.extra_deps         = [['activesupport','>= 2.0.2']]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
