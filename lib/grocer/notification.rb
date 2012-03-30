require 'json'
require_relative 'no_payload_error'

module Grocer
  class Notification
    attr_accessor :identifier, :expiry, :device_token, :alert, :badge, :sound

    def initialize(payload = {})
      @identifier = 0

      payload.each do |key, val|
        send("#{key}=", val)
      end
    end

    def to_bytes
      validate_payload
      payload = encoded_payload

      [1, identifier, expiry_epoch_time, device_token_length, sanitized_device_token, payload.length].pack('CNNnH64n') << payload
    end

    private

    def validate_payload
      fail NoPayloadError unless alert || badge
    end

    def encoded_payload
      JSON.dump(payload_hash)
    end

    def payload_hash
      aps_hash = { }
      aps_hash[:alert] = alert if alert
      aps_hash[:badge] = badge if badge
      aps_hash[:sound] = sound if sound

      { aps: aps_hash }
    end

    def expiry_epoch_time
      expiry.to_i
    end

    def sanitized_device_token
      device_token.tr(' ', '') if device_token
    end

    def device_token_length
      32
    end
  end
end
