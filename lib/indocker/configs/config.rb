module Indocker::Configs
  class Config
    def scope
      @scope ||= Hash.new({})
    end

    def option(name, group: :default, type: :string)
      define_singleton_method(name) do |value = nil, &block|
        write_value = block || value

        if write_value
          validate!(name, write_value, type)

          write_setting(name, write_value, group)
        else
          read_setting(name)
        end
      end
    end

    def config(name, group: :default, &block)
      subconfiguration = Indocker::Configs::Config.new
      subconfiguration.instance_exec(&block)
  
      option(name, group: group, type: :config)
      send(name, subconfiguration)
    end

    def read_setting(key)
      read_value = scope[key.to_s][:value]
      
      read_value.is_a?(Proc) ? read_value.call : read_value
    end

    def write_setting(key, value, group)
      scope[key.to_s] = {
        value: value,
        group: group
      }
    end

    def validate!(name, value, type)
      value_type = cast_class_to_type(value)

      if type != value_type
        raise Indocker::Errors::ConfigOptionTypeMismatch, 
          "Expected option #{name.inspect} => #{value.inspect} to be a #{type.inspect}, not a #{value_type.inspect}"
      end

      nil
    end

    def cast_class_to_type(value)
      case value
      when Proc
        cast_class_to_type(value.call)
      when TrueClass
        :boolean
      when FalseClass
        :boolean
      when Indocker::Configs::Config
        :config
      else
        Indocker::StringUtils.underscore(value.class.name).to_sym
      end
    end

    def method_missing(method, *args, &block)
      raise "Undefined keyword #{method.inspect} for Indocker configuration file"
    end
  end
end