require 'smart_ioc'
<<<<<<< HEAD
require 'docker-api'
require 'logger'

SmartIoC.find_package_beans(:indocker, __dir__)

require 'indocker/errors'
require 'indocker/cli'
require 'indocker/docker_api'

require 'indocker/utils/ioc_container'

require 'indocker/image/image_metadata'
require 'indocker/image/image_metadata_factory'
require 'indocker/image/image_dsl'
require 'indocker/image/image_context'
require 'indocker/image/image_repository'
require 'indocker/image/image_build_service'
require 'indocker/image/image_dependencies_manager'
require 'indocker/image/image_evaluator'

require 'indocker/container/container_metadata'
require 'indocker/container/container_repository'
require 'indocker/container/container_metadata_factory'
require 'indocker/container/container_runner_service'

require 'indocker/partial/partial_metadata'
require 'indocker/partial/partial_repository'

require 'indocker/directives/directives_runner'
require 'indocker/directives/base'
require 'indocker/directives/partial'
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
require 'indocker/directives/prepare_directives/copy'


module Indocker
  DOCKERFILE_NAME = 'Dockerfile'
  BUILD_DIR       = 'tmp/build'

  class << self
    def images
      @images ||= []
    end

    def define_image(name, &definition)
      images << ioc.image_metadata_factory.create(name, &definition)
    end

    def containers
      @containers ||= []
    end

    def define_container(name, repo:, tag: Indocker::ImageMetadata::DEFAULT_TAG)
      containers << ioc.container_metadata_factory.create(name, repo: repo, tag: tag)
    end

    def partials
      @partials ||= []
    end

    def define_partial(name, &definition)
      partials << Indocker::PartialMetadata.new(name, &definition)
    end

    def logger
      @logger ||= ioc.logger
    end

    def setup(&block)
      instance_exec &block
    end

    def root(dir = nil)
      return @root if @root

      @root = dir
=======

require 'indocker/errors'

# directives
require 'indocker/directives/from'
require 'indocker/directives/workdir'
require 'indocker/directives/run'
require 'indocker/directives/copy'
require 'indocker/directives/cmd'
require 'indocker/directives'

# entities
require 'indocker/config'
require 'indocker/image'
require 'indocker/container'

SmartIoC.find_package_beans(:indocker, __dir__)

class IocContainer
  class << self
    def [](meth, *args)
      SmartIoC::Container.get_instance.get_bean(meth, *args)
    end
  end

  def self.method_missing(meth, *args, &block)
    SmartIoC::Container.get_instance.get_bean(meth, *args)
  end
end

def ioc
  IocContainer
end

module Indocker
  SETTINGS_FOLDER = '.indocker'
  CONFIG_FILENAME = 'indocker.config.rb'

  class << self
    attr_reader :images, :containers

    def init(path)
      @root       = ioc.config_locator.locate(path.to_s)
      @config     = Indocker::Config.new
      @images     = []
      @containers = []

      load config_file_path

      docker_images_path = @config.docker_images.map {|path| File.join(root, SETTINGS_FOLDER, path)}

      Dir[*docker_images_path].each {|file| load File.expand_path(file)}
    end

    def config
      return @config if @config
      raise Indocker::Errors::ProjectNotInitialized
    end

    def root
      return @root if @root
      raise Indocker::Errors::ProjectNotInitialized
    end

    def config_file_path
      File.expand_path(File.join(root, SETTINGS_FOLDER, CONFIG_FILENAME))
    end

    def setup(&block)
      @config.setup(&block)
    end

    def image(name, &block)
      @images ||= []
      @images.push Indocker::Image.new(name, &block)
    end

    def container(name, &block)
      @containers ||= []
      @containers.push Indocker::Container.new(name, &block)
>>>>>>> 2e2ce2f2b0632666091ae8757530353dd3258f52
    end
  end
end