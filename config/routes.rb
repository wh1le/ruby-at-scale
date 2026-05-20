# frozen_string_literal: true

map('/report')  { run RubyAtScale::Controllers::ReportsController }
map('/limited') { run RubyAtScale::Controllers::RateLimitController }
