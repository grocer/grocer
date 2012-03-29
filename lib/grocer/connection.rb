
module Grocer
  class Connection
    attr_accessor :certificate, :passphrase, :gateway, :port

    def initialize(options = {})
      @certificate = options[:certificate]
      @passphrase = options.fetch(:passphrase) { nil }
      @gateway = options.fetch(:gateway) { 'gateway.sandbox.push.apple.com' }
      @port = options.fetch(:port) { 2195 }
    end

  end
end
