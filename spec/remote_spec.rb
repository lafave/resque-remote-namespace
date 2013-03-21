require 'spec_helper'

describe Resque::Plugins::RemoteNamespace do
	let(:queue) 					 { :default }
	let(:remote_namespace) { 'resque:bar' }
	
	before :each do
		from_namespace remote_namespace do
			Resque.remove_queue(queue)
		end
	end
	
	it 'passes resque lint' do
		lambda {
			Resque::Plugin.lint(Resque::Plugins::RemoteNamespace)
		}.should_not raise_error
	end
	
	it 'response to remote_enqueue_to' do
	  Resque.should respond_to :remote_enqueue_to
	end
	
	it 'response to remote_dequeue_from' do
	  Resque.should respond_to :remote_dequeue_from
	end

	describe '#remote_enqueue_to' do
		subject { Resque.remote_enqueue_to queue, remote_namespace, 'TestJob', 'foo' }

		it 'temporarily changes Resque.redis.namespace' do
      Resque.redis.should_receive(:namespace=)
        .with('resque:foo')
        .once

      Resque.redis.should_receive(:namespace=)
        .with('resque:bar')
        .once

      subject
    end

    it 'enqueues a job' do
    	expect {
    		subject
    	}.to change {
    		from_namespace remote_namespace do
    			Resque.size(queue)
    		end
    	}.from(0).to(1)
    end
	end

  describe '#remote_enqueue_to_in' do
    subject       { Resque.remote_enqueue_to_in 5, queue, remote_namespace, 'TestJob', 'foo' }

    it 'temporarily changes the Resque.redis.namespace' do
      Resque.redis.should_receive(:namespace=)
        .with('resque:foo')
        .once

      Resque.redis.should_receive(:namespace=)
        .with('resque:bar')
        .once

      subject
    end

    it 'enqueues a job' do
      expect {
        subject
      }.to change {
        from_namespace remote_namespace do
          Resque.delayed_queue_schedule_size
        end
      }.by(1)
    end
  end

	describe '#remote_dequeue_from' do
		subject { Resque.remote_dequeue_from queue, remote_namespace, 'TestJob', 'foo' }

		it 'temporarily changes Resque.redis.namespace' do
      Resque.redis.should_receive(:namespace=)
        .with('resque:foo')
        .once

      Resque.redis.should_receive(:namespace=)
        .with('resque:bar')
        .once

      subject
    end

    it 'dequeues a job' do
    	Resque.remote_enqueue_to queue, remote_namespace, 'TestJob', 'foo'

    	expect {
    		subject
    	}.to change {
    		from_namespace remote_namespace do
    			Resque.size(queue)
    		end
    	}.from(1).to(0)
    end
	end
end