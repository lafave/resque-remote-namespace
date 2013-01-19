module Resque
  module Plugins
    module RemoteNamespace

      # Remote enqueue of a job by temporarily changing the Resque redis
      #   namespace.
      #
      # @param [ String ] queue The queue to enqueue the job to.
      # @param [ String ] namespace The namespace to enqueue the job to.
      # @param [ String ] klass The class name of the job to enqueue.
      # @param [ Array ] args The arguments to the job being remotely enqueued.
      def remote_enqueue_to(queue, namespace, klass, *args)
        temp_namespace(namespace) do
          Resque::Job.create(queue.to_sym, klass, *args)
        end
      end

      # Remote dequeue of a job by temporarily changin gthe Resque redis
      #   namespace.
      #
      # @param [ String ] queue The queue to dequeue the job from.
      # @param [ String ] namespace The namespace to dequeue the job from.
      # @param [ String ] klass The class name of the job to enqueue.
      # @param [ Array ] args The arguments to the job being remotely dequeued.
      def remote_dequeue_from(queue, namespace, klass, *args)
        temp_namespace(namespace) do
          Resque::Job.destroy(queue.to_sym, klass, *args)
        end
      end

      private

      # Temporarily change the Resque namespace
      #
      # @example
      #   temp_namespace('my-temp-namespace') do
      #     Resque.redis.destroy_all_the_things
      #   end
      #
      # @param [String] namespace the temporary namespace
      def temp_namespace(namespace)
        original_namespace = Resque.redis.namespace
        Resque.redis.namespace = namespace
        yield
      ensure
        Resque.redis.namespace = original_namespace
      end
    end
  end

  # Pull the remote methods into the Resque module
  extend Plugins::RemoteNamespace
end
