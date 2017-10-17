module Indocker::Errors         
  class ImageIsNotDefined                 < StandardError; end 
  class PartialIsNotDefined               < StandardError; end 
  class ContainerIsNotDefined             < StandardError; end
  class CircularImageDependency           < StandardError; end
  class ImageForContainerDoesNotExist     < StandardError; end
  class ContainerImageAlreadyDefined      < StandardError; end
  class DockerDoesNotInstalled            < StandardError; end
  class ConfigFilesDoesNotFound           < StandardError; end
  class ConfigOptionTypeMismatch          < StandardError; end
  class DockerRegistryAuthenticationError < StandardError; end
end