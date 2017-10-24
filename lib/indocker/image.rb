class Indocker::Image
  include Indocker::Directives

  DOCKERFILE = 'Dockerfile'

  attr_reader :name, :build_dir

  def initialize(name, &block)
    @name            = name
    @block           = block
    @docker_commands = []

    instance_eval &block
  end

  def before_build(&block)
    @before_build = block
  end

  def prepare!
    instance_eval &@before_build
  end

  def build(tmp_dir)
    @build_dir = File.join(tmp_dir, name)
    FileUtils.mkdir_p(@build_dir)

    dockerfile_path = File.join(@build_dir, DOCKERFILE)
    dockerfile!(dockerfile_path)

    ioc.shell_commands.run_command("docker build -t #{name} #{@build_dir}")
  end

  def dockerfile
    @docker_commands.map(&:to_s).join("\n")
  end

  def dockerfile!(file)
    File.open(file, 'w') { |f| f.write dockerfile }
  end
end