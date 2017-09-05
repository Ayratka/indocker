class Indocker::Container
  include Indocker::Directives

  IMAGE_NOT_FOUND_MESSAGE = /Unable to find image/

  def initialize(name, &block)
    @name  = name
    @block = block
    @image = nil
    @docker_commands = []

    instance_eval &block
  end

  def run
    ioc.shell_commands.run_command_with_result("docker run --name #{@name} --rm #{image}") do |result|
      tmp_dir = File.expand_path(__dir__, 'tmp')

      if message_not_found?(result)
        Indocker.images.detect {|i| i.name == image}.build(tmp_dir) 
        run
      end
    end
  end
  
  def image
    return @image if @image

    raise Indocker::Errors::UndefindedImageForContainer
  end

  def from_image(image_name)
    @image = image_name
  end

  def message_not_found?(msg)
    msg =~ IMAGE_NOT_FOUND_MESSAGE
  end
end