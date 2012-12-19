require 'delegate'
require 'grocer/extensions/deep_symbolize_keys'
require 'grocer/connection'

module Grocer
  class PushConnection < SimpleDelegator

    PRODUCTION_GATEWAY = 'gateway.push.apple.com'
    LOCAL_GATEWAY = '127.0.0.1'
    SANDBOX_GATEWAY = 'gateway.sandbox.push.apple.com'

    def initialize(options)
      options = apply_defaults(options)
      super(Connection.new(options))
    end

    private

    def defaults
      {
        gateway: find_default_gateway,
        port: 2195
      }
    end

    def find_default_gateway
      case Grocer.env.downcase
      when 'production'
        PRODUCTION_GATEWAY
      when 'test'
        LOCAL_GATEWAY
      else
        SANDBOX_GATEWAY
      end
    end

    def apply_defaults(options)
      options.extend Extensions::DeepSymbolizeKeys
      defaults.merge(options.deep_symbolize_keys)
    end

  end
end
