# frozen_string_literal: true

RSpec.describe RubyAtScale::CacheStampede::Solution do

  let(:key) { "test:cache:#{SecureRandom.hex(4)}" }
  let(:redis) { Redis.new }

  after { redis.del(key, "#{key}:lock") }

  subject { described_class.new(redis) }

  describe '#initialize' do
    it 'assigns redis to @redis' do
      expect(subject.instance_variable_get(:@redis)).to an_instance_of(Redis)
    end
  end

  describe '#fetch' do
    it 'returns computed value on cache miss' do
      result = subject.fetch(key, ttl: 10) { 'computed' }
      expect(result).to eq('computed')
    end

    it 'returns cached value on cache hit' do
      subject.fetch(key, ttl: 10) { 'first' }

      result = subject.fetch(key, ttl: 10) { 'second' }

      expect(result).to eq('first')
    end

    it 'stores value in redis with ttl' do
      subject.fetch(key, ttl: 5) { 'stored' }

      expect(redis.get(key)).to eq('stored')

      expect(redis.ttl(key)).to be_between(1, 5)
    end

    it 'executes block only once for concurrent requests' do
      call_count = Concurrent::AtomicFixnum.new(0)

      threads = 10.times.map do
        Thread.new do
          subject.fetch(key, ttl: 10) do
            call_count.increment
            sleep 0.1
            'result'
          end
        end
      end

      threads.each(&:join)
      expect(call_count.value).to eq(1)
    end

    it 'waiting threads get the cached value' do
      results = Concurrent::Array.new

      threads = 10.times.map do
        Thread.new do
          result = subject.fetch(key, ttl: 10) do
            sleep 0.1
            'shared_value'
          end
          results << result
        end
      end

      threads.each(&:join)
      expect(results).to all(eq('shared_value'))
    end

    it 'releases lock after computation' do
      subject.fetch(key, ttl: 10) { 'done' }
      expect(redis.get("#{key}:lock")).to be_nil
    end

    it 'lock has TTL to prevent deadlock' do
      redis.set("#{key}:lock", true, nx: true, ex: 1)
      sleep 1.1
      result = subject.fetch(key, ttl: 10) { 'recovered' }
      expect(result).to eq('recovered')
    end
  end
end
