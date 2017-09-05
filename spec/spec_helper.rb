$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'byebug'
require 'fileutils'
require 'indocker'

require_relative 'helpers/example_application_helper'

SmartIoC.find_package_beans(:indocker, File.expand_path('../lib', __dir__))

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.mock_with :rspec
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
