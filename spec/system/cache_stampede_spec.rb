# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Cache Stampede', :system do
  it 'prevents multiple DB queries under concurrent load' do
    script = File.expand_path('bin/cache_stampede_test', __dir__)
    output = `bash #{script} 2>&1`
    puts output
    expect(output).to include('✓')
    expect(output).not_to include('✗')
  end
end
