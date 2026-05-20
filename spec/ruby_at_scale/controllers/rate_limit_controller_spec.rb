# frozen_string_literal: true

RSpec.describe RubyAtScale::Controllers::RateLimitController, type: :controller do
  def app
    described_class
  end

  let(:limiter) { instance_double(RubyAtScale::RateLimiter::SlidingWindow) }

  before do
    stub_const('RubyAtScale::Controllers::RateLimitController::LIMITER', limiter)
  end

  describe 'GET /' do
    context 'when under limit' do
      before { allow(limiter).to receive(:allow?).and_return(true) }

      it 'returns 200' do
        get '/'

        expect(last_response.status).to eq(200)
      end

      it 'returns allowed status in json' do
        get '/'

        body = JSON.parse(last_response.body)

        expect(body['status']).to eq('allowed')
        expect(body).to have_key('pid')
      end
    end

    context 'when over limit' do
      before { allow(limiter).to receive(:allow?).and_return(false) }

      it 'returns 429' do
        get '/'

        expect(last_response.status).to eq(429)
      end

      it 'returns rate_limited status in json' do
        get '/'

        body = JSON.parse(last_response.body)
        expect(body['status']).to eq('rate_limited')
      end
    end

    it 'calls allow? with client ip' do
      allow(limiter).to receive(:allow?).with('127.0.0.1').and_return(true)

      get '/'

      expect(limiter).to have_received(:allow?).with('127.0.0.1')
    end
  end
end
