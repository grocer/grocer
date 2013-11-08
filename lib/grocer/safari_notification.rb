require 'grocer/notification'

module Grocer
  # Public: A specialized form of a Grocer::Notification for sending
  # Safari push notifications
  #
  # Examples
  #
  #   Grocer::SafariNotification.new(
  #     device_token: '...',
  #     title: '...',
  #     body: '...',
  #     action: '...',
  #     url_args: ['...']
  #   )
  #
  #   #=>
  #   {
  #     "aps": {
  #       "alert": {
  #         "title": "...",
  #         "body": "...",
  #         "action": "..."
  #       },
  #       "url-args": ["..."]
  #     }
  #   }
  class SafariNotification < Notification

    attr_reader :url_args

    def initialize(payload = {})
      self.alert = {}
      super(payload)
    end

    def title
      alert[:title]
    end

    def title=(title)
      alert[:title] = title
      @encoded_payload = nil
    end

    def body
      alert[:body]
    end

    def body=(body)
      alert[:body] = body
      @encoded_payload = nil
    end

    def action
      alert[:action]
    end

    def action=(action)
      alert[:action] = action
      @encoded_payload = nil
    end

    def url_args
      Array(@url_args)
    end

    def url_args=(args)
      @url_args = args.dup
      @encoded_payload = nil
    end

    private

    def validate_payload
      fail ArgumentError.new('missing title') unless title
      fail ArgumentError.new('missing body') unless body
      super
    end

    def payload_hash
      aps_hash = { alert: alert }
      aps_hash[:'url-args'] = url_args
      { aps: aps_hash }
    end
  end
end
