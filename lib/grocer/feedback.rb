require 'grocer/failed_delivery_attempt'

module Grocer
  class Feedback
    include Enumerable

    def initialize(connection)
      @connection = connection
    end

    def each
      return to_enum unless block_given?

      feedback_items.each { |f| yield f }
    end

    private

    def feedback_items
      @feedback_items ||= read_feedback
    end

    def read_feedback
      Enumerator.new { |yielder|
        while buf = @connection.read(FailedDeliveryAttempt::LENGTH)
          yielder.yield(FailedDeliveryAttempt.new(buf))
        end
      }.to_a
    end
  end
end
