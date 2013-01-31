require 'grocer/push_connection'
require 'thread'

module Grocer
  class PushConnectionPool
    def initialize(options)
      @options   = options.dup
      @available = []
      @used      = {}
      @expiries  = {}
      @size      = @options.delete(:pool_size) || 5

      @condition = ConditionVariable.new
      @lock      = Mutex.new
    end

    def acquire
      instance = nil
      begin
        @lock.synchronize do
          if instance = @available.pop
            @used[instance] = instance
          elsif @size > (@available.size + @used.size)
            instance = new_instance
            @used[instance] = instance
          else
            @condition.wait(@lock)
          end
        end
      end until instance

      yield instance
    ensure
      release(instance)
    end

    def write(bytes)
      acquire { |connection| connection.write(bytes) }
    end

    private

    def new_instance
      PushConnection.new(@options)
    end

    def release(instance)
      @lock.synchronize do
        @available << @used.delete(instance) if instance
        @condition.broadcast
      end
    end
  end
end
