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

    def write(content)
      ssl.connect unless ssl.connected?
      ssl.write(content)
    end

    private

    def ssl
      @ssl_connection ||=
        Grocer::SSLConnection.new(certificate: certificate,
                                  passphrase: passphrase,
                                  gateway: gateway,
                                  port: port)
    end
  end
end
