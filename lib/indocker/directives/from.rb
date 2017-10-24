module Indocker
  module Directives
    class From
      COMMAND = 'FROM'
      
      def initialize(image_name)
        @image_name = image_name
      end
    
      def to_s
        "#{COMMAND} #{@image_name}"
      end
    end
  end
end