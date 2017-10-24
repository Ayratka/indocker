<<<<<<< HEAD
module Indocker::Errors     
  class ImageIsNotDefined             < StandardError; end 
  class PartialIsNotDefined           < StandardError; end 
  class ContainerIsNotDefined         < StandardError; end
  class CircularImageDependency       < StandardError; end
  class ImageForContainerDoesNotExist < StandardError; end
=======
module Indocker
  module Errors
    class ProjectNotInitialized       < StandardError; end
    class ConfigFileDoesNotExist      < StandardError; end
    class UndefindedImageForContainer < StandardError; end
  end
>>>>>>> 2e2ce2f2b0632666091ae8757530353dd3258f52
end