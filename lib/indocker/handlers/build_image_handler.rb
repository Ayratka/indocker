class Indocker::Handlers::BuildImageHandler < Indocker::Handlers::Base
  include SmartIoC::Iocify

  bean :build_image_handler

  def handle(image_name:, exec_path:)
    Indocker.init(exec_path)

    image = Indocker.images.detect {|image| image.name == image_name}

    puts image.build
  end
end