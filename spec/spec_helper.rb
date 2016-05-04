# Set the correct environment for testing.

ENV[ 'RACK_ENV' ] = 'test'

# Configure the code coverage analyser.

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter '/spec/'
end

# Configure the test suite.

require 'rack/test'

RSpec.configure do | config |
  config.disable_monkey_patching!

  config.expect_with :rspec do | expectations |
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do | mocks |
    mocks.verify_partial_doubles = true
  end

  config.color                            = true
  config.tty                              = true
  config.warnings                         = false
  config.run_all_when_everything_filtered = true
  config.order                            = :random

  Kernel.srand( config.seed )
end
