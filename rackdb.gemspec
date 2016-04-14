# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib", "rackdb", "version.rb")
require 'date'

Gem::Specification.new do |s|
  s.name        = %q{rackdb}
  s.version     = RackDB::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = Date.today.to_s
  s.authors     = [ 'Andrew Hodgkinson' ]
  s.email       = 'ahodgkin@rowing.org.uk'
  s.has_rdoc    = false
  s.homepage    = 'http://github.com/pond/rackdb'
  s.summary     = 'Database console for Rack applications'
  s.description = 'Database console for Ruby applications running on Rack with ActiveRecord and following the Rails "config/database.yml" database configuration pattern'
  s.executables = [ 'rackdb' ]
  s.files       = Dir[ 'bin/*' ] + Dir[ 'lib/**/*.rb' ] + [ 'LICENSE', 'README.md', 'CHANGELOG.md' ]
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.1'

  s.add_dependency             'rack',         '~> 1.6'
  s.add_dependency             'activerecord', '~> 4'

  s.add_development_dependency 'rack-test',    '~> 0.6'
  s.add_development_dependency 'rspec',        '~> 3.3'
  s.add_development_dependency 'rspec-mocks',  '~> 3.3'
end
