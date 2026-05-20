# frozen_string_literal: true

RSpec.describe RubyAtScale::RateLimiter::Solution do

  let(:redis) { Redis.new }
  let(:client_id) { "test:client:#{SecureRandom.hex(4)}" }

  after { redis.del("rate_limit:#{client_id}") }

  subject { described_class.new(redis: redis, max_requests: 3, window_seconds: 2) }

  describe '#initialize' do
    it 'assigns redis to @redis' do
      expect(subject.instance_variable_get(:@redis)).to be(redis)
    end

    it 'assigns max_requests to @max_requests' do
      expect(subject.instance_variable_get(:@max_requests)).to eq(3)
    end

    it 'assigns window_seconds to @window_seconds' do
      expect(subject.instance_variable_get(:@window_seconds)).to eq(2)
    end
  end

  describe '#allow?' do
    it 'allows requests under the limit' do
      3.times { expect(subject.allow?(client_id)).to be true }
    end

    it 'denies requests over the limit' do
      3.times { subject.allow?(client_id) }

      expect(subject.allow?(client_id)).to be false
    end

    it 'allows again after window expires' do
      3.times { subject.allow?(client_id) }
      expect(subject.allow?(client_id)).to be false

      sleep 2.1

      expect(subject.allow?(client_id)).to be true
    end

    it 'tracks clients independently' do
      3.times { subject.allow?(client_id) }

      expect(subject.allow?("#{client_id}:other")).to be true
    end

    it 'is atomic under concurrent access' do
      allowed = Concurrent::AtomicFixnum.new(0)

      threads = Array.new(50) do
        Thread.new do
          r = Redis.new
          limiter = described_class.new(redis: r, max_requests: 10, window_seconds: 10)
          allowed.increment if limiter.allow?(client_id)
        end
      end

      threads.each(&:join)

      expect(allowed.value).to eq(10)
    end
  end
end
