module Grocer
  class Connection
    attr_accessor :certificate, :passphrase, :gateway, :port

    def initialize(options = {})
      options.each do |key, val|
        send("#{key}=", val)
      end
    end
  end
end
