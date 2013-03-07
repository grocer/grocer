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

    def checkout_connection
      connection = nil
      begin
        synchronize do
          if connection = available.pop
            used << connection
          elsif size > (available.size + used.size)
            connection = new_connection
            used << connection
          else
            wait_for_signal
          end
        end
      end until connection

      yield connection
    ensure
      checkin(connection)
    end

    def write(content)
      checkout_connection do |connection|
        connection.write(content)
      end
    end

    private

    def new_connection
      PushConnection.new(options)
    end

    def checkin(connection)
      return unless connection

      synchronize do
        available << used.delete(connection)
        signal
      end
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
