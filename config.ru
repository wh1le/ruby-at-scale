# frozen_string_literal: true

require_relative 'lib/ruby_at_scale'

get '/report' do
  content_type :json

  result = RubyAtScale::CacheStampede.cache.fetch('expensive_report', ttl: 60) do
    RubyAtScale::CacheStampede.redis.incr('stampede:query_count')
    RubyAtScale::CacheStampede.expensive_query
  end

  { pid: Process.pid, result_size: result.to_s.length }.to_json
end

run Sinatra::Application
