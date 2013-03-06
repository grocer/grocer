require 'grocer/push_connection'
require 'thread'

module Grocer
  class PushConnectionPool
    DEFAULT_POOL_SIZE = 5

    attr_reader :available, :condition, :lock, :options, :size, :used

    def initialize(options)
      @options   = options.dup
      @available = []
      @used      = {}
      @size      = @options.delete(:pool_size) || DEFAULT_POOL_SIZE

      @condition = ConditionVariable.new
      @lock      = Mutex.new
    end

    def acquire
      instance = nil
      begin
        synchronize do
          if instance = available.pop
            used[instance] = instance
          elsif size > (available.size + used.size)
            instance = new_instance
            used[instance] = instance
          else
            condition.wait(lock)
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
      PushConnection.new(options)
    end

    def release(instance)
      return unless instance

      synchronize do
        available << used.delete(instance)
        condition.signal
      end
    end

    def synchronize(&block)
      lock.synchronize(&block)
    end
  end
end
