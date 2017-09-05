require 'smart_ioc'

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
    end
  end
end