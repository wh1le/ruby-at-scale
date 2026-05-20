# frozen_string_literal: true

require 'redis'

# Naive rate limiter - uses simple GET/INCR with TTL (fixed window).
# This has race conditions under concurrent load:
#
# - Multiple workers can read count=9, all increment, exceeding the limit
# - Fixed window allows burst at boundary (2x limit in 1 second)

module RubyAtScale
  module RateLimiter
    class SlidingWindow
      KEY_PREFIX = 'rate_limit:'

      def initialize(redis: Redis.new, max_requests: 10, window_seconds: 60)
        @redis = redis
        @max_requests = max_requests
        @window_seconds = window_seconds
      end

      def allow?(client_id)
        # your solution here
        true
      end
    end
  end
end
