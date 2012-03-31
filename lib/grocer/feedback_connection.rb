require 'delegate'
require_relative 'connection'

module Grocer
  class FeedbackConnection < SimpleDelegator

    PRODUCTION_GATEWAY = 'feedback.push.apple.com'
    SANDBOX_GATEWAY = 'feedback.sandbox.push.apple.com'

    def initialize(options)
      options = defaults.merge(options)
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
