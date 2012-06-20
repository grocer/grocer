require 'openssl'
require 'socket'
require 'thread'
require 'grocer/extensions/deep_symbolize_keys'

module Grocer
  class SSLServer
    attr_accessor :port

    def initialize(options = {})
      options.extend Extensions::DeepSymbolizeKeys
      options = defaults.merge(options.deep_symbolize_keys)
      options.each { |k, v| send("#{k}=", v) }
    end

    def defaults
      {
        port: 2195
      }
    end

    def accept
      while socket = ssl_socket.accept
        yield socket if block_given?
      end
    end

    def close
      if @ssl_socket && !@ssl_socket.closed?
        begin
          @ssl_socket.shutdown
        rescue Errno::ENOTCONN
          # Some platforms raise this if the socket is not connected. Not sure
          # how to avoid it.
        end

        @ssl_socket.close
      end

      @ssl_socket = nil
      @socket = nil
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
