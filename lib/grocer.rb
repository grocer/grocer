require 'grocer/error_response'
require 'grocer/error_response_checker'
require 'grocer/feedback'
require 'grocer/feedback_connection'
require 'grocer/newsstand_notification'
require 'grocer/notification'
require 'grocer/passbook_notification'
require 'grocer/push_connection'
require 'grocer/pusher'
require 'grocer/server'
require 'grocer/version'

module Grocer
  Error = Class.new(::StandardError)
  InvalidCommandError = Class.new(Error)
  InvalidFormatError = Class.new(Error)
  NoGatewayError = Class.new(Error)
  NoPayloadError = Class.new(Error)
  NoPortError = Class.new(Error)
  PayloadTooLargeError = Class.new(Error)
  CertificateExpiredError = Module.new

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
