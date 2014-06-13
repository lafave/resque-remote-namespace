# -*- encoding: utf-8 -*-
require File.expand_path('../lib/resque-remote-namespace/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'resque-remote-namespace'
  s.version     = Resque::Plugins::RemoteNamespace::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['BJ Neilsen', 'Adam LaFave']
  s.email       = ['bj.neilsen@gmail.com', 'lafave.adam@gmail.com']
  s.homepage    = 'http://github.com/lafave/resque-remote-namespace'
  s.summary     = %Q{
    Resque plugin to allow remote enqueueing and dequeueing of jobs across
    different namespaces.
  }
  s.description = %Q{
    Remotely enqueueing and dequeueing jobs across Redis namespaces should
    be simpler. BJ Neilsen laid a solid foundation for this gem, which is
    forked off of his gem resque-remote. That said, these two gems provide a
    different set of methods for remote enqueueing and dequeueing.

    If all you need is remote enqueueing within the same namespace, use
    resque-remote.
  }

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'resque-remote-namespace'

  s.add_dependency 'resque', '~> 1.0'
  s.add_dependency 'resque-scheduler', '~> 3.0'

  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'rspec', '~> 2.8'

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
