require 'thread'
require_relative 'notification_reader'
require_relative 'ssl_server'

module Grocer
  class Server
    attr_reader :notifications

    def initialize(server)
      @server = server

      @clients = []
      @notifications = Queue.new
    end

    def accept
      Thread.new {
        @server.accept { |client|
          @clients << client

          Thread.new {
            # Read from client into queue
            NotificationReader.new(client).each(&notifications.method(:push))
          }
        }
      }
    end

    def close
      @server.close
      @clients.each(&:close)
    end
  end
end
