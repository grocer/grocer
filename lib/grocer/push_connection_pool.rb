require 'grocer/push_connection'
require 'thread'

module Grocer
  class PushConnectionPool
    DEFAULT_POOL_SIZE = 5

    attr_reader :available, :condition, :lock, :options, :size, :used

    def initialize(options)
      @options   = options.dup
      @available = []
      @used      = []
      @size      = options.fetch(:pool_size, DEFAULT_POOL_SIZE)
      @condition = ConditionVariable.new
      @lock      = Mutex.new
    end

    def write(content)
      with_connection do |connection|
        connection.write(content)
      end
    end

    def with_connection
      connection = checkout_connection
      yield connection
    ensure
      checkin(connection)
    end

    private

    def checkout_connection
      connection = nil

      synchronize do
        connection = wait_for_connection
        checkout(connection)
      end

      connection
    end

    def wait_for_connection
      wait_for_signal until connection_available?

      find_connection
    end

    def checkout(connection)
      used << connection
    end

    def checkin(connection)
      synchronize do
        available << used.delete(connection)
        signal
      end
    end

    def find_connection
      reuse_connection || new_connection
    end

    def reuse_connection
      available.pop
    end

    def new_connection
      PushConnection.new(options)
    end

    def connection_available?
      !available.empty? || !at_connection_limit?
    end

    def at_connection_limit?
      available.size + used.size >= size
    end

    def wait_for_signal
      condition.wait(lock)
    end

    def signal
      condition.signal
    end

    def synchronize(&block)
      lock.synchronize(&block)
    end
  end
end
