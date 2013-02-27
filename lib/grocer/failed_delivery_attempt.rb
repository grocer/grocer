module Grocer
  class FailedDeliveryAttempt
    LENGTH = 38

    attr_accessor :timestamp, :device_token

    def initialize(binary_tuple)
      # N   =>  4 byte timestamp
      # n   =>  2 byte token_length
      # H64 => 32 byte device_token
      seconds, _, @device_token = binary_tuple.unpack('NnH64')
      raise InvalidFormatError unless seconds && @device_token
      @timestamp = Time.at(seconds)
    end
  end
end
