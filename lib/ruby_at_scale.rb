# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'redis'

module RubyAtScale
  VERSION = '0.1.1'

  def self.db_connection
    @db_connection ||= begin
      ActiveRecord::Base.establish_connection(database_config)
      ActiveRecord::Base.connection
    end
  end

  def self.env
    ENV.fetch('RACK_ENV', 'production')
  end

  def self.redis
    @redis ||= Redis.new
  end

  def self.version
    VERSION
  end

  def self.database_config
    YAML.safe_load(
      ERB.new(
        File.read(
          database_config_path
        )
      ).result
    )[env]
  end

  def self.database_config_path
    File.expand_path('../config/database.yml', __dir__)
  end
end

require_relative 'ruby_at_scale/cache_stampede'
require_relative 'ruby_at_scale/rate_limiter'
require_relative 'ruby_at_scale/controllers'
