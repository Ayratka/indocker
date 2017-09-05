module Indocker
  module Directives
    class Copy
      COMMAND = 'Copy'
      
      def initialize(*args)
        @args = args.join(' ')
      end
    
      def to_s
        "#{COMMAND} #{@args}"
      end
    end
  end
end