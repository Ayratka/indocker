module Indocker
  module Directives
    def from(image_name)
      @docker_commands.push Indocker::Directives::From.new(image_name)
    end
  
    def workdir(path)
      @docker_commands.push Indocker::Directives::Workdir.new(path)
    end
  
    def run(*args)
      @docker_commands.push Indocker::Directives::Run.new(*args)
    end
  
    def copy(*args)
      @docker_commands.push Indocker::Directives::Copy.new(*args)
    end
  
    def cmd(*args)
      @docker_commands.push Indocker::Directives::Cmd.new(args)
    end
  end
end