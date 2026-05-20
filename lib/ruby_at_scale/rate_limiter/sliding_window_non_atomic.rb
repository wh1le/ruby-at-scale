# frozen_string_literal: true

require 'redis'

# Non-atomic sliding window rate limiter.
# Same ZREMRANGEBYSCORE/ZCARD/ZADD approach as the Solution,
# but each command is a separate Redis call — race condition
# between ZCARD (check) and ZADD (write).
#
# Under concurrency, multiple threads read count=9, all pass,
# all ZADD — exceeding the limit.

module RubyAtScale
  module RateLimiter
    class SlidingWindowNonAtomic
      KEY_PREFIX = 'rate_limit'

      def initialize(redis: Redis.new, max_requests: 10, window_seconds: 60)
        @redis = redis
        @max_requests = max_requests
        @window_seconds = window_seconds
      end

      def allow?(client_id)
        now = Time.now.to_f
        key = "#{KEY_PREFIX}:#{client_id}"

        @redis.zremrangebyscore(key, '-inf', now - @window_seconds)

        count = @redis.zcard(key)

        if count < @max_requests
          @redis.zadd(key, now, "#{now}:#{rand}")
          @redis.expire(key, @window_seconds.ceil + 1)

          true
        else
          false
        end
      end
    end
  end
end
