# frozen_string_literal: true

module RubyAtScale
  module Controllers
    class ReportsController < ApplicationController
      CACHE = RubyAtScale::CacheStampede::Cache.new(RubyAtScale.redis)

      get '/' do
        result = CACHE.fetch('expensive_report', ttl: 60) do
          RubyAtScale.redis.incr('stampede:query_count')

          RubyAtScale.db_connection.execute('SELECT pg_sleep(10), COUNT(*) FROM events').to_a.to_s
        end

        json_response(pid: Process.pid, result_size: result.to_s.length)
      end
    end
  end
end
