require 'grocer/notification'

module Grocer
  # Public: A specialized form of a Grocer::Notification which requires neither
  # an alert nor badge to be present in the payload. It requires only the
  # `device_token`, and allows an optional `expiry` and `identifier` to be set.
  #
  # Examples
  #
  #   Grocer::PassbookNotification.new(device_token: '...')
  class PassbookNotification < Notification

    private

    def validate_payload
      true
    end

  end
end
