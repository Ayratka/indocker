module ExampleApplicationHelper
  def initilize_application(path = nil)
    @example_project_path ||= File.expand_path('../../tmp/example', __dir__)
    @real_example_path      = File.expand_path('../example', __dir__)

    FileUtils.mkdir_p(@example_project_path)
    FileUtils.cp_r(@real_example_path, File.dirname(@example_project_path))
  end

  def reset_application
    FileUtils.rm_rf(@example_project_path) if @example_project_path
  end

  def example_project_path
    return @example_project_path if @example_project_path
    
    raise "Example project not initialized yet. Run #initilize_application to create it"
  end
end