class Indocker::Config
  SETTING_KEYS = [:docker_registry, :docker_images, :env_files]

  SETTING_KEYS.each do |key|
    define_method(key) do |value = nil, &block|
      fetch_setting(key, value, &block)
    end
  end

  def initialize
    @settings = {}
  end

  def setup(&block)
    return @setup if block.nil?
    
    instance_eval &block
    @setup = block
  end

  private

  def fetch_setting(key, value = nil, &block)
    if value.nil? && block.nil?
      read_setting(key)
    else
      value_to_write = value.nil? ? block : value
      write_setting(key, value_to_write)
    end
  end

  def read_setting(key)
    result = @settings[key.to_s]
    result = result.call if result.is_a?(Proc)

    result
  end

  def write_setting(key, value)
    @settings[key.to_s] = value
  end
end