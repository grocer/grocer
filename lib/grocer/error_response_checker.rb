require 'grocer/error_response'

module Grocer
  class InvalidErrorResponseHandler < StandardError
  end
end

module Grocer
  class ErrorResponseChecker
    attr_accessor :handler, :thread

    def initialize(handler)
      raise InvalidErrorResponseHandler unless handler.arity == 1
      @handler = handler
    end

    def continually_check_for_responses(connection)
      Thread.new do
        check_for_responses(connection) while connection
      end
    end

    def check_for_responses(connection)
      binary_tuple = connection.read(ErrorResponse::LENGTH)
      error_response = ErrorResponse.new(binary_tuple)
      handler.call(error_response)
    end
  end
end
