require 'socket'
require 'openssl'
require 'forwardable'
require 'stringio'
require 'grocer/error_response_checker'

module Grocer
  class SSLConnection
    extend Forwardable
    def_delegators :@ssl, :write, :read

    attr_accessor :certificate, :passphrase, :gateway, :port

    def initialize(options = {})
      options.each do |key, val|
        send("#{key}=", val)
      end
    end

    def connected?
      !@ssl.nil?
    end

    def connect
      context = OpenSSL::SSL::SSLContext.new

      if certificate

        if certificate.respond_to?(:read)
          cert_data = certificate.read
          certificate.rewind if certificate.respond_to?(:rewind)
        else
          cert_data = File.read(certificate)
        end

        context.key  = OpenSSL::PKey::RSA.new(cert_data, passphrase)
        context.cert = OpenSSL::X509::Certificate.new(cert_data)
      end

      @sock            = TCPSocket.new(gateway, port)
      @sock.setsockopt   Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true
      @ssl             = OpenSSL::SSL::SSLSocket.new(@sock, context)
      @ssl.sync        = true
      @ssl.connect
    end

    def disconnect
      @ssl.close if @ssl
      @ssl = nil

      @sock.close if @sock
      @sock = nil
    end

    def reconnect
      disconnect
      connect
    end
  end
end
