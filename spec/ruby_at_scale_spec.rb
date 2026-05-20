# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/ruby_at_scale'

RSpec.describe RubyAtScale do
  describe '.db_connection' do
    it 'returns an ActiveRecord connection' do
      expect(RubyAtScale.db_connection).to be_a(ActiveRecord::ConnectionAdapters::AbstractAdapter)
    end

    it 'memoizes the connection' do
      expect(RubyAtScale.db_connection).to be(RubyAtScale.db_connection)
    end
  end

  describe '.redis' do
    it 'returns a Redis instance' do
      expect(RubyAtScale.redis).to be_a(Redis)
    end

    it 'memoizes the instance' do
      expect(RubyAtScale.redis).to be(RubyAtScale.redis)
    end
  end

  describe '.version' do
    it 'returns a version string' do
      expect(RubyAtScale.version).to eq('0.1.1')
    end
  end

  describe '.database_config' do
    it 'returns config for current environment' do
      config = RubyAtScale.database_config

      expect(config['database']).to eq('ruby_at_scale_test')
      expect(config['adapter']).to eq('postgresql')
      expect(config['host']).to eq('localhost')
    end
  end

  describe '.database_config_path' do
    it 'points to an existing file' do
      expect(File.exist?(RubyAtScale.database_config_path)).to be true
    end

    it 'returns path to database.yml' do
      expect(RubyAtScale.database_config_path).to end_with('config/database.yml')
    end
  end
end
