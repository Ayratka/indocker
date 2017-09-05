class Indocker::ConfigLocator
  include SmartIoC::Iocify

  bean :config_locator

  def locate(path)
    path = File.expand_path(path)

    raise Indocker::Errors::ConfigFileDoesNotExist if path == '/'

    return path if File.exists?(potential_config_file(path))

    locate(File.dirname(path))
  end

  private

  def potential_config_file(path)
    File.join(path, Indocker::SETTINGS_FOLDER, Indocker::CONFIG_FILENAME)
  end
end