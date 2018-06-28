require "bundler/setup"
require "sorabji"
require 'ostruct'

module SpecHelpers
  def parser
    SorabjiParser.new
  end

  def parse(str)
    parser.parse(str)
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.formatter = :documentation

  # Disable RSpec exposing methods globally on `Module` and `main`
  # config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before { Sorabji.reset_config! }
  config.include(SpecHelpers)
end
