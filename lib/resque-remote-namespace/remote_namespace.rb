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
        from_namespace(namespace) do
          Resque::Job.create(queue.to_sym, klass, *args)
        end
      end

      # Remote enqueue of a job in the future by temporarily changing the 
      #   Resque redis namespace.
      #
      # @param [ String ] number_of_seconds_from_now The number of seconds from
      #   now to enqueue the job at.
      # @param [ String ] queue The queue to enqueue the job to.
      # @param [ String ] namespace The namespace to enqueue the job to.
      # @param [ String ] klass The class name of the job to enqueue.
      # @param [ Array ] args The arguments to the job being remotely enqueued.
      def remote_enqueue_to_in(number_of_seconds_from_now, queue, namespace, klass, *args)
        time_to_enqueue = Time.now + number_of_seconds_from_now

        from_namespace(namespace) do
          Resque.enqueue_at_with_queue(queue, time_to_enqueue, klass, *args)
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
        from_namespace(namespace) do
          Resque::Job.destroy(queue.to_sym, klass, *args)
        end
      end
    end
  end

  # Pull the remote methods into the Resque module
  extend Plugins::RemoteNamespace
end
