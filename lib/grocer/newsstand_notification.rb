require 'grocer/notification'

module Grocer
  # Public: A specialized form of a Grocer::Notification which requires neither
  # an alert nor badge to be present in the payload. It requires only the
  # `device_token` to be set.
  #
  # Examples
  #
  #   Grocer::NewsstandNotification.new(device_token: '...')
  class NewsstandNotification < Notification

    private

    def validate_payload
      true
    end
    
    def payload_hash
      { "content-available" => 1 }
    end

  end
end
