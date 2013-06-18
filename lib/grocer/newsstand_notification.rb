require 'grocer/notification'

module Grocer
  # Public: A specialized form of a Grocer::Notification which requires neither
  # an alert nor badge to be present in the payload. It requires only the
  # `device_token` to be set.
  #
  # Examples
  #
  #   Grocer::NewsstandNotification.new(device_token: '...')
  #     #=> { aps: { 'content-available' => 1 } }
  class NewsstandNotification < Notification

    def initialize(payload = {})
      super(payload.merge(content_available: true))
    end

    private

    def validate_payload
      true
    end

  end
end
