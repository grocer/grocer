module Grocer
  class Pusher
    def initialize(connection_pool)
      @connection_pool = connection_pool
    end

    def push(notification)
      @connection_pool.with_connection do |connection|
        connection.write(notification.to_bytes)
      end
    end
  end
end
