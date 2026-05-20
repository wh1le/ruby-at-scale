# frozen_string_literal: true

require 'sinatra/base'

module RubyAtScale
  module Controllers
    class ApplicationController < Sinatra::Base
      configure do
        set :show_exceptions, false
      end

      helpers do
        def json_response(hash, status_code = 200)
          content_type :json
          status status_code
          hash.to_json
        end
      end
    end
  end
end
