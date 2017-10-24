<<<<<<< HEAD
$LOAD_PATH.unshift(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift(__dir__)

require 'indocker'
require 'fileutils'
require 'byebug'

SmartIoC.set_load_proc do |location|
  require(location)
end

Indocker.root(File.expand_path(File.join(__dir__, '..')))

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.after(:each) do
    ioc.docker_api.all_containers.each do |container|
      container.delete(force: true) if container.info['Image'].match(/^indocker/)
    end

    ioc.docker_api.all_images.each do |image|
      image.remove(force: true) if image.info['RepoTags'].find {|rt| rt =~ /^indocker/}
    end

    Indocker.images.clear
    Indocker.containers.clear
  end
end



=======
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
>>>>>>> 2e2ce2f2b0632666091ae8757530353dd3258f52
