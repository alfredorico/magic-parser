module Magic
  module Parser
    class FileLoader

      attr_reader :path_file, :batch_size

      def initialize(path_file:)
        @path_file = path_file
        @batch_size = 4
      end

      def unformatted_numbers
        unless @unformatted_numbers
          @unformatted_numbers = []
          File.open(path_file) do |file|
            file.lazy.each_slice(batch_size).with_index do |policy_number_from_file, index|
              policy_number_from_file.map! do |line| 
                # Cleaning stuff
                line = line.gsub("\n","")
                line[0..26] 
              end
              unformatted_number = policy_number_from_file.take(3)
              (raise FileLoaderError, "WRONG NUMBER OF CHARACTERS IN FILE (POLICY NUMBER #{index+1})") if unformatted_number.select{ |line| line.size != 27 }.any?
              (raise FileLoaderError, "NOT ALLOWED CHARACTER IN FILE (POLICY NUMBER #{index+1})")  if unformatted_number.select { |line| (line =~ (/^[-_| ]+$/)) == nil }.any? 
              @unformatted_numbers << unformatted_number
            end            
          end        
        end
        @unformatted_numbers
      end

    end
  end
end