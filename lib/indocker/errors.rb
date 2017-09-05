module Indocker
  module Errors
    class ProjectNotInitialized       < StandardError; end
    class ConfigFileDoesNotExist      < StandardError; end
    class UndefindedImageForContainer < StandardError; end
  end
end