# frozen_string_literal: true

map('/report')  { run ReportsController }
map('/limited') { run RateLimitController }
