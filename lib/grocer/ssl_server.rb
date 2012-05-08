require 'openssl'
require 'socket'
require 'thread'

module Grocer
  class SSLServer
    attr_accessor :port

    def initialize(options = {})
      options.each { |k, v| send("#{k}=", v) }
    end

    def accept
      while socket = ssl_socket.accept
        yield socket if block_given?
      end
    end

    def close
      if @ssl_socket
        @ssl_socket.close
        @ssl_socket = nil
        @socket = nil
      end
    end

    private

    def ssl_socket
      @ssl_socket ||= OpenSSL::SSL::SSLServer.new(socket, context)
    end

    def socket
      @socket ||= TCPServer.new('127.0.0.1', port)
    end

    def context
      @context ||= OpenSSL::SSL::SSLContext.new.tap do |c|
        c.cert = OpenSSL::X509::Certificate.new(File.read(crt_path))
        c.key  = OpenSSL::PKey::RSA.new(File.read(key_path))
      end
    end

    def crt_path
      File.join(File.dirname(__FILE__), "test", "server.crt")
    end

    def key_path
      File.join(File.dirname(__FILE__), "test", "server.key")
    end
  end
end
