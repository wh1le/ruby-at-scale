# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Rate Limiter', :system do
  it 'enforces rate limit under concurrent load' do
    script = File.expand_path('bin/rate_limiter_test', __dir__)
    output = `bash #{script} 2>&1`
    puts output
    expect(output).to include('✓')
    expect(output).not_to include('✗')
  end
end
