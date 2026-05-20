# frozen_string_literal: true

module RubyAtScale
  module Controllers
    class RateLimitController < ApplicationController
      LIMITER = RubyAtScale::RateLimiter::SlidingWindow.new(
        redis: Redis.new,
        max_requests: 10,
        window_seconds: 60
      )

      get '/' do
        client_id = request.ip

        if LIMITER.allow?(client_id)
          json_response(pid: Process.pid, status: 'allowed')
        else
          json_response({ pid: Process.pid, status: 'rate_limited' }, 429)
        end
      end
    end
  end
end
