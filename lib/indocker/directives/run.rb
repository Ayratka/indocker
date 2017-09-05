module Indocker
  module Directives
    class Run
      COMMAND = 'RUN'
      
      def initialize(*args)
        @args = args.join(' ')
      end
    
      def to_s
        "#{COMMAND} #{@args}"
      end
    end
  end
end