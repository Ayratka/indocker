class Indocker::ShellCommandsUtil
  include SmartIoC::Iocify

  bean :shell_util

  inject :logger

  def run_command(command, with_sudo: false, &block)
    if $use_sudo && with_sudo
      command = "sudo #{command}"
    end

    puts command
    system(command, out: $stdout, err: :out)

    exit 1 if !$?.success?

    if block_given?
      yield
    end
  end

  def run_command_with_result(command, with_sudo: false, &block)
    if $use_sudo && with_sudo
      command = "sudo #{command}"
    end

    logger.debug command

    IO.popen(command, err: [:child, :out]) do |io|
      result = io.read
      logger.debug result

      if block_given?
        yield result
      end
    end
  end
end