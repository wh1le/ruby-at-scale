# frozen_string_literal: true

RSpec.describe RubyAtScale::Controllers::ApplicationController, type: :controller do
  let(:test_app) do
    Class.new(described_class) do
      get '/test' do
        json_response(message: 'hello')
      end

      get '/error' do
        json_response({ error: 'too many' }, 429)
      end
    end
  end

  def app
    test_app
  end

  describe '#json_response' do
    it 'returns json content type' do
      get '/test'

      expect(last_response.content_type).to include('application/json')
    end

    it 'returns serialized json body' do
      get '/test'

      body = JSON.parse(last_response.body)
      expect(body['message']).to eq('hello')
    end

    it 'defaults to 200 status' do
      get '/test'

      expect(last_response.status).to eq(200)
    end

    it 'supports custom status codes' do
      get '/error'

      expect(last_response.status).to eq(429)
    end
  end
end
