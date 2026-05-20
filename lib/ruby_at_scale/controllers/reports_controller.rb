# frozen_string_literal: true

module RubyAtScale
  module Controllers
    class ReportsController < ApplicationController
      CACHE = RubyAtScale::CacheStampede::Cache.new(RubyAtScale.redis)

      get '/' do
        $stdout.puts "[#{Process.pid}] Request received"

        result = CACHE.fetch('expensive_report', ttl: 60) do
          $stdout.puts "[#{Process.pid}] Cache MISS — executing DB query"
          RubyAtScale.redis.incr('stampede:query_count')

          ActiveRecord::Base.connection.execute('SELECT pg_sleep(5), COUNT(*) FROM events').to_a.to_s
        end

        $stdout.puts "[#{Process.pid}] Responding (result_size=#{result.to_s.length})"
        json_response(pid: Process.pid, result_size: result.to_s.length)
      end
    end
  end
end
