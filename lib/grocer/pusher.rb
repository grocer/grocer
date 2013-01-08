module Grocer
  class Pusher
    def initialize(connection)
      @connection = connection
    end

    def push(notification)
      @connection.write(notification.to_bytes)
    end

    def error_response_handler(&block)
      @connection.error_response_handler(block)
    end
  end
end
