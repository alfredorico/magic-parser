module Magic
  module Parser
    class FileLoaderError < StandardError
      def initialize(msg="Error loading unparsed policy numbers")
        super
      end
    end
  end
end
