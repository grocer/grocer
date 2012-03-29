require 'forwardable'
require 'grocer/ssl_connection'

module Grocer
  class Connection
    attr_accessor :certificate, :passphrase, :gateway, :port

    def initialize(options = {})
      @certificate = options[:certificate]
      @passphrase = options.fetch(:passphrase) { nil }
      @gateway = options.fetch(:gateway) { 'gateway.sandbox.push.apple.com' }
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
      @ssl_connection ||=
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
