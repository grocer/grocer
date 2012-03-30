require_relative "grocer/version"
require_relative "grocer/notification"
require_relative "grocer/connection"
require_relative "grocer/feedback"

module Grocer

  def self.env
    ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
  end

end
