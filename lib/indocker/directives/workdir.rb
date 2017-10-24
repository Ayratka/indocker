module Indocker
  module Directives
    class Workdir
      COMMAND = 'WORKDIR'
      
      def initialize(path)
        @path = path
      end
    
      def to_s
        "#{COMMAND} #{@path}"
      end
    end
  end
end