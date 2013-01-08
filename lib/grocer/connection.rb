require 'grocer'
require 'grocer/ssl_connection'

module Grocer
  class Connection
    attr_reader :certificate, :checker, :gateway, :passphrase, :port, :retries

    def initialize(options = {})
      @certificate = options.fetch(:certificate) { nil }
      @passphrase = options.fetch(:passphrase) { nil }
      @gateway = options.fetch(:gateway) { fail NoGatewayError }
      @port = options.fetch(:port) { fail NoPortError }
      @retries = options.fetch(:retries) { 3 }
    end

    def read(size = nil, buf = nil)
      with_connection do
        ssl.read(size, buf)
      end
    end

    def write(content)
      with_connection do
        ssl.write(content)
      end
    end

    def connect
      ssl.connect unless ssl.connected?
      checker.continually_check_for_responses if checker
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

    def destroy_connection
      return unless @ssl_connection

      @ssl_connection.disconnect rescue nil
      @ssl_connection = nil
    end

    def with_connection
      attempts = 1
      begin
        connect
        yield
      rescue => e
        if e.class == OpenSSL::SSL::SSLError && e.message =~ /certificate expired/i
          e.extend(CertificateExpiredError)
          raise
        end

        raise unless attempts < retries

        destroy_connection
        attempts += 1
        retry
      end
    end

    def error_response_handler(&block)
      @checker = ErrorResponseChecker.new(block)
      continually_check_for_responses
    end

    def continually_check_for_responses
      with_connection do
        checker.continually_check_for_responses(ssl)
      end
    end
  end
end
