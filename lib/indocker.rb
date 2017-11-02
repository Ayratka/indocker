require 'smart_ioc'
require 'docker-api'

require 'byebug' # TODO: remove after release

SmartIoC.find_package_beans(:indocker, __dir__)
SmartIoC.set_load_proc do |location|
  require(location)
end

Docker.options = { read_timeout: 600, write_timeout: 600, chunk_size: 1 }

require 'indocker/version'

require 'indocker/errors'
require 'indocker/cli'
require 'indocker/docker_api'
require 'indocker/dsl_context'

require 'indocker/configs/config'
require 'indocker/configs/config_factory'
require 'indocker/configs/locator'

require 'indocker/utils/logger'
require 'indocker/utils/logger_factory'
require 'indocker/utils/test_logger_factory'
require 'indocker/utils/tar_helper'
require 'indocker/utils/string_utils'
require 'indocker/utils/registry_authenticator'
require 'indocker/utils/render_util'
require 'indocker/utils/render_namespace'

require 'indocker/handlers/performable'
require 'indocker/handlers/container_run'
require 'indocker/handlers/container_stop'

require 'indocker/utils/ioc_container'

require 'indocker/envs/env_metadata'
require 'indocker/envs/manager'
require 'indocker/envs/loader'

require 'indocker/image/image_metadata'
require 'indocker/image/image_metadata_factory'
require 'indocker/image/image_dsl'
require 'indocker/image/image_metadata_repository'
require 'indocker/image/image_builder'
require 'indocker/image/image_dependencies_manager'
require 'indocker/image/image_evaluator'

require 'indocker/container/container_metadata'
require 'indocker/container/container_metadata_repository'
require 'indocker/container/container_metadata_factory'
require 'indocker/container/container_manager'
require 'indocker/container/container_evaluator'
require 'indocker/container/container_dsl'

require 'indocker/partial/partial_metadata'
require 'indocker/partial/partial_metadata_repository'

require 'indocker/directives/image_directives_runner'
require 'indocker/directives/container_directives_runner'
require 'indocker/directives/base'
require 'indocker/directives/partial'

require 'indocker/networks/network_metadata'
require 'indocker/networks/network_metadata_factory'
require 'indocker/networks/network_metadata_repository'

require 'indocker/volumes/volume_metadata'
require 'indocker/volumes/volume_metadata_factory'
require 'indocker/volumes/volume_metadata_repository'

require 'indocker/directives/docker_directives/base'
require 'indocker/directives/docker_directives/cmd'
require 'indocker/directives/docker_directives/entrypoint'
require 'indocker/directives/docker_directives/env'
require 'indocker/directives/docker_directives/copy'
require 'indocker/directives/docker_directives/from'
require 'indocker/directives/docker_directives/run'
require 'indocker/directives/docker_directives/workdir'

require 'indocker/directives/prepare_directives/base'
require 'indocker/directives/prepare_directives/docker_cp'

require 'indocker/directives/container_directives/base'
require 'indocker/directives/container_directives/from'
require 'indocker/directives/container_directives/network'
require 'indocker/directives/container_directives/env_file'
require 'indocker/directives/container_directives/ports'
require 'indocker/directives/container_directives/expose'
require 'indocker/directives/container_directives/depends_on'
require 'indocker/directives/container_directives/ready'

require 'indocker/git/git_helper'

module Indocker
  DOCKERFILE_NAME = 'Dockerfile'

  class << self
    def define_image(name, &definition)
      ioc.image_metadata_repository.put(
        ioc.image_metadata_factory.create(name, &definition)
      )
    end

    def define_container(name, &definition)
      ioc.container_metadata_repository.put(
        ioc.container_metadata_factory.create(name, &definition)
      )
    end

    def define_partial(name, &definition)
      ioc.partial_metadata_repository.put(
        Indocker::PartialMetadata.new(name, &definition)
      )
    end

    def define_network(name)
      ioc.network_metadata_repository.put(
        ioc.network_metadata_factory.create(name)
      )
    end

    def define_volume(name)
      ioc.volume_metadata_repository.put(
        ioc.volume_metadata_factory.create(name)
      )
    end

    def setup(&block)
      ioc.config.set(&block)
    end

    def root(dir = nil)
      ioc.config.root(dir)
    end

    def cache_dir(dir = nil)
      ioc.config.cache_dir(dir)
    end

    def build_dir(dir = nil)
      ioc.config.build_dir(dir)
    end
  end
end