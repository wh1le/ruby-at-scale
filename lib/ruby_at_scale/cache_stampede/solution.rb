# frozen_string_literal: true

require 'redis'

# Problem: Cache Stampede Prevention
#
# You have an expensive DB query (takes 2 seconds). Result is cached for 60 seconds.
# When cache expires, 1000 requests hit simultaneously. All see cache miss.
# All 1000 hit the DB at once → DB goes down.
#
# Implement a cache-fetch method that ensures only ONE process rebuilds the cache
# while others wait for the result.
#
# You have:
#   - Redis instance (used as both cache and lock store)
#   - A block that computes the expensive value
#
# Implement:
#   cache.fetch(key, ttl: 60) { expensive_computation } -> cached value
#
# Constraints:
#   - Only one process should execute the block when cache is empty
#   - Other processes should wait (poll) until the value is available
#   - Lock should timeout after 5 seconds (in case builder crashes)
#   - Must be safe under 100 concurrent processes

module RubyAtScale
  module CacheStampede
    class Solution
      LOCK_TTL = 15
      POLL_INTERVAL = 0.05

      def initialize(redis = Redis.new)
        @redis = redis
      end

      def fetch(key, ttl: 60)
        cached = cached_value(key)
        lock_key = "#{key}:lock"

        return cached unless cached.to_s.empty?

        if lock!(lock_key)
          result = yield
          redis.set(key, result, ex: ttl)
          redis.del(lock_key)
          result
        else
          await_redis_cache(key)
        end
      end

      private

      attr_reader :redis

      def await_redis_cache(key)
        deadline = waiting_deadline

        loop do
          sleep(POLL_INTERVAL)
          value = redis.get(key)
          return value if value
          break if Time.now > deadline
        end
      end

      def waiting_deadline
        Time.now + LOCK_TTL
      end

      def lock!(lock_key)
        redis.set(lock_key, true, nx: true, ex: LOCK_TTL)
      end

      def cached_value(key)
        redis.get(key)
      end
    end
  end
end
