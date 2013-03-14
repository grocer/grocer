require 'grocer/notification'

module Grocer
  # Public: A specialized form of a Grocer::Notification which only requires a
  # `push_magic` and `device_token` to be present in the payload.
  #
  # Examples
  #
  #   Grocer::PassbookNotification.new(device_token: '...', push_magic: '...')
  class MobileDeviceManagementNotification < Notification
    attr_accessor :push_magic

    private

    def payload_hash
      { mdm: push_magic }
    end

    def validate_payload
      raise NoPayloadError unless push_magic
      fail InvalidFormatError if alert || badge || custom 
      fail PayloadTooLargeError if payload_too_large?
    end
  end
end
