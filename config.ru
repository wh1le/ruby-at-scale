# frozen_string_literal: true

require_relative 'lib/ruby_at_scale'

map('/report')  { run RubyAtScale::Controllers::ReportsController }
map('/limited') { run RubyAtScale::Controllers::RateLimitController }
