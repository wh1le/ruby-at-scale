# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'redis'

module RubyAtScale
  module CacheStampede
    def self.db_connection
      @db_connection ||= begin
        RubyAtScale::Database.establish_connection
        ActiveRecord::Base.connection
      end
    end

    def self.redis
      @redis ||= Redis.new
    end

    def self.cache
      @cache ||= Cache.new(redis)
    end

    def self.expensive_query
      db_connection.execute('SELECT pg_sleep(10), COUNT(*) FROM events').to_a.to_s
    end
  end
end

require_relative 'ruby_at_scale/database'
require_relative 'ruby_at_scale/cache_stampede'
