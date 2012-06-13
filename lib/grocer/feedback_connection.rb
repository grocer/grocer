require 'delegate'
require 'grocer/extensions/deep_symbolize_keys'
require 'grocer/connection'

module Grocer
  class FeedbackConnection < SimpleDelegator

    PRODUCTION_GATEWAY = 'feedback.push.apple.com'
    SANDBOX_GATEWAY = 'feedback.sandbox.push.apple.com'

    def initialize(options)
      options.extend Extensions::DeepSymbolizeKeys
      options = defaults.merge(options.deep_symbolize_keys)
      super(Connection.new(options))
    end

    private

    def defaults
      {
        gateway: find_default_gateway,
        port: 2196
      }
    end

    def find_default_gateway
      Grocer.env == 'production' ? PRODUCTION_GATEWAY : SANDBOX_GATEWAY
    end

  end
end
