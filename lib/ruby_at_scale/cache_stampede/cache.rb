# frozen_string_literal: true

require 'redis'

# Problem: Cache Stampede Prevention
#
# You have an expensive DB query (takes 2 seconds or more). Result is cached for 60 seconds.
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
    class Cache
      LOCK_TTL = 15
      POLL_INTERVAL = 0.05

      def initialize(redis = Redis.new)
        @redis = redis
      end

      def fetch(_key, ttl: 60)
        # Your solution here
        yield
      end
    end
  end
end
