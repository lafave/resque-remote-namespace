`resque-remote-namespace` is a fork of the [remote-namespace gem](https://github.com/localshred/resque-remote) that allows for remote enqueueing and dequeueing of jobs on different redis namespaces.

# Installation

**Note: You must have a version of Resque installed or added to your Gemfile for `resque-remote-namespace` to work. Resque Version 0.10.0 has been tested to work with the current release of `resque-remote-namespace`.**

Add it to your Bundler `Gemfile`:

	# Gemfile
	gem 'resque', '0.10.0'
	gem 'resque-remote-namespace', :git => 'git://github.com/lafave/resque-remote-namespace.git'

And then run a `bundle install`.

# Usage

## Enqueueing
```ruby
# Enqueues TestJob to the "default" queue on the "resque:foo" redis namespace with "foo" as its sole argument.
Resque.remote_enqueue_to 'default', 'resque:foo', 'TestJob', 'foo'
```

## Dequeueing
```ruby
# Dequeues TestJob from the "default" queue on the "resque:foo" redis namespace with "foo" as its sole argument
Resque.remote_dequeue_from 'default', 'resque:foo', 'TestJob', 'foo'
```

## Worker Processing

The job you are remotely enqueueing does not need to exist in the application you are in enqueueing it from, however if `Resque.inline` is set to `true` (as is often the case in a development or test environment) then Resque may attempt to execute the job in the current application, depending on which version of Resque you are using.  This will cause a `NameError` to be raised.

To fix this, just create a stub of the job you are remote enqueueing. Ex:
```ruby
# Stub of TestJob. Actual implementation is located in X.
class TestJob
  def self.perform(param1) end
end
```

Note that the actual implementation of the remote job does not need to have its `@queue` defined.

```ruby
class TestJob
  # no queue needed

  def self.perform(param1)
    ...
  end
end
```

