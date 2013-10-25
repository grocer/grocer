require 'grocer/error_response'
require 'grocer/feedback'
require 'grocer/feedback_connection'
require 'grocer/mobile_device_management_notification'
require 'grocer/newsstand_notification'
require 'grocer/notification'
require 'grocer/passbook_notification'
require 'grocer/safari_notification'
require 'grocer/push_connection'
require 'grocer/pusher'
require 'grocer/server'
require 'grocer/version'

module Grocer
  Error = Class.new(::StandardError)
  InvalidFormatError = Class.new(Error)
  NoGatewayError = Class.new(Error)
  NoPayloadError = Class.new(Error)
  NoPortError = Class.new(Error)
  PayloadTooLargeError = Class.new(Error)
  CertificateExpiredError = Module.new
  InvalidCommandError = Class.new(Error)

  def self.env
    ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
  end

  def self.feedback(options)
    connection = FeedbackConnection.new(options)
    Feedback.new(connection)
  end

  def self.pusher(options)
    connection = PushConnection.new(options)
    Pusher.new(connection)
  end

  def self.server(options = { })
    ssl_server = SSLServer.new(options)
    Server.new(ssl_server)
  end
end
