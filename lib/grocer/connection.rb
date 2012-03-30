require 'forwardable'
require 'grocer'
require 'grocer/no_certificate_error'
require 'grocer/ssl_connection'

module Grocer
  class Connection
    attr_accessor :certificate, :passphrase, :gateway, :port

    PRODUCTION_PUSH_GATEWAY = 'gateway.push.apple.com'
    SANDBOX_PUSH_GATEWAY = 'gateway.sandbox.push.apple.com'

    def initialize(options = {})
      @certificate = options[:certificate]
      @passphrase = options.fetch(:passphrase) { nil }
      @gateway = options.fetch(:gateway) { find_default_gateway }
      @port = options.fetch(:port) { 2195 }
    end

    def read(size = nil, buf = nil)
      with_open_connection do
        ssl.read(size, buf)
      end
    end

    def write(content)
      with_open_connection do
        ssl.write(content)
      end
    end

    private

    def ssl
      @ssl_connection ||= build_connection
    end

    def build_connection
      fail Grocer::NoCertificateErrror unless certificate

      Grocer::SSLConnection.new(certificate: certificate,
                                passphrase: passphrase,
                                gateway: gateway,
                                port: port)
    end

    def find_default_gateway
      Grocer.env == 'production' ? PRODUCTION_PUSH_GATEWAY : SANDBOX_PUSH_GATEWAY
    end

    def with_open_connection(&block)
      ssl.connect unless ssl.connected?
      block.call
    end
  end
end
