require 'byebug'
require 'siren_client'

RSpec.configure do |config|
  # Ensure we only use `expect` and not `should`.
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
