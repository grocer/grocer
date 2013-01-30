module Grocer
  class Pusher
    def initialize(pool)
      @pool = pool
    end

    def push(notification)
      @pool.write(notification.to_bytes)
    end
  end
end
