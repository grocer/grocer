require_relative "grocer/version"
require_relative "grocer/notification"
require_relative "grocer/connection"
require_relative "grocer/feedback"
require_relative "grocer/pusher"

module Grocer

  def self.env
    ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
  end

  def self.pusher(options)
    connection = Connection.new(options)
    Pusher.new(connection)
  end
end
