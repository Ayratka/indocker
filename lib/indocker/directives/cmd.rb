module Indocker
  module Directives
    class Cmd
      COMMAND = 'CMD'
      
      def initialize(*args)
        @args = args.join(' ')
      end
    
      def to_s
        "#{COMMAND} #{@args}"
      end
    end
  end
end