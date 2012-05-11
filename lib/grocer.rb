require_relative 'grocer/feedback'
require_relative 'grocer/notification'
require_relative 'grocer/feedback_connection'
require_relative 'grocer/push_connection'
require_relative 'grocer/pusher'
require_relative 'grocer/version'
require_relative 'grocer/server'

module Grocer

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
