require 'grocer'
require 'grocer/no_certificate_error'
require 'grocer/no_gateway_error'
require 'grocer/no_port_error'
require 'grocer/ssl_connection'

module Grocer
  class Connection
    attr_reader :certificate, :passphrase, :gateway, :port

    def initialize(options = {})
      @certificate = options.fetch(:certificate) { fail NoCertificateError }
      @gateway = options.fetch(:gateway) { fail NoGatewayError }
      @port = options.fetch(:port) { fail NoPortError }
      @passphrase = options.fetch(:passphrase) { nil }
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
      Grocer::SSLConnection.new(certificate: certificate,
                                passphrase: passphrase,
                                gateway: gateway,
                                port: port)
    end

    def with_open_connection(&block)
      ssl.connect unless ssl.connected?
      block.call
    end
  end
end
