# frozen_string_literal: true

require 'redis'

module RubyAtScale
  module RateLimiter
    class Solution
      SCRIPT = <<~LUA
        local key = KEYS[1]
        local window = tonumber(ARGV[1])
        local max = tonumber(ARGV[2])
        local now = tonumber(ARGV[3])
        local member = ARGV[4]

        redis.call('ZREMRANGEBYSCORE', key, '-inf', now - window)
        local count = redis.call('ZCARD', key)

        if count < max then
          redis.call('ZADD', key, now, member)
          redis.call('EXPIRE', key, math.ceil(window) + 1)
          return 1
        else
          return 0
        end
      LUA

      KEY_PREFIX = 'rate_limit'

      def initialize(redis: Redis.new, max_requests: 10, window_seconds: 60)
        @redis = redis
        @max_requests = max_requests
        @window_seconds = window_seconds
      end

      def allow?(client_id)
        now = Time.now.to_f
        result = @redis.eval(
          SCRIPT,
          keys: ["#{KEY_PREFIX}:#{client_id}"],
          argv: [@window_seconds, @max_requests, now, "#{now}:#{rand}"]
        )
        result == 1
      end
    end
  end
end
