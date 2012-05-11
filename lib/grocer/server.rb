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
        begin
          @server.accept { |client|
            @clients << client

            Thread.new {
              begin
                NotificationReader.new(client).each(&notifications.method(:push))
              rescue Errno::EBADF, NoMethodError
                # Expected when another thread closes the socket
              end
            }
          }
        rescue Errno::EBADF
          # Expected when another thread closes the socket
        end
      }
    end

    def close
      if @server
        @server.close
        @server = nil
      end

      @clients.each(&:close)
      @clients = []
    end
  end
end
