# frozen_string_literal: true

require 'active_record'

module RubyAtScale
  module Database
    def self.establish_connection
      ActiveRecord::Base.establish_connection(config)
    end

    def self.config
      @config ||= YAML.safe_load(ERB.new(File.read(config_path)).result)['development']
    end

    def self.config_path
      File.expand_path('../../config/database.yml', __dir__)
    end
  end
end
