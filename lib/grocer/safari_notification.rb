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
  #       }
  #     },
  #     "url-args": ["..."]
  #   }
  class SafariNotification < Notification

    attr_reader :title, :body, :action, :url_args

    def initialize(payload = {})
      payload.each do |key, val|
        send("#{key}=", val)
      end
      notification = {alert: {}, custom: {}}
      notification[:alert][:title] = title if title
      notification[:alert][:body] = body if body
      notification[:alert][:action] = action if action
      notification[:custom][:'url-args'] = url_args if url_args
      super(notification)
    end

    def title=(title)
      @title = title
    end

    def body=(body)
      @body = body
    end

    def action=(action)
      @action = action
    end

    def url_args=(args)
      @url_args = [*args]
    end

    private

    def validate_payload
      fail ArgumentError.new('missing title') unless title
      fail ArgumentError.new('missing body') unless body
      super
    end

  end
end
