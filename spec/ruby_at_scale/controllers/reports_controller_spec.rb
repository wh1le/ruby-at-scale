# frozen_string_literal: true

RSpec.describe RubyAtScale::Controllers::ReportsController, type: :controller do
  def app
    described_class
  end

  let(:cache) { instance_double(RubyAtScale::CacheStampede::Cache) }
  let(:redis) { instance_double(Redis) }

  before do
    allow(RubyAtScale).to receive(:redis).and_return(redis)
    stub_const('RubyAtScale::Controllers::ReportsController::CACHE', cache)
  end

  describe 'GET /' do
    it 'fetches from cache with correct key and ttl' do
      allow(cache).to receive(:fetch).with('expensive_report', ttl: 60).and_return('cached_result')

      get '/'

      expect(cache).to have_received(:fetch).with('expensive_report', ttl: 60)
    end

    it 'returns json with pid and result_size' do
      allow(cache).to receive(:fetch).and_return('some_data')

      get '/'

      body = JSON.parse(last_response.body)
      expect(body).to have_key('pid')
      expect(body).to have_key('result_size')
    end

    it 'returns 200 status' do
      allow(cache).to receive(:fetch).and_return('data')

      get '/'

      expect(last_response.status).to eq(200)
    end
  end
end
