# frozen_string_literal: true

environment ENV.fetch('RACK_ENV', 'production')

workers 4
threads_count = 5
threads threads_count, threads_count

port 9292
