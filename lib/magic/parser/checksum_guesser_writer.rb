module Magic
  module Parser
    class ChecksumGuesserWriter

      def initialize(input_file_path:, output_file_path:)
        @input_file_path = input_file_path
        @output_file = File.open(output_file_path,'w')
      end

      def write_guessed_policy_codes
        File.open(@input_file_path) do |file|
          file.lazy.each do |line|
            policy_number = line.split(' ')[0]
            code = line.split(' ')[1]
            if code == 'ERR' or code == 'ILL'
              policy_numbers_guessed = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: policy_number).policy_numbers_guessed # just pick one if multiple alternatives
              if policy_numbers_guessed.empty?
                @output_file.write("#{policy_number} ILL\n")
              elsif policy_numbers_guessed.size > 1
                @output_file.write("#{policy_numbers_guessed[0]} AMB\n")
              else  
                @output_file.write("#{policy_numbers_guessed[0]}\n")
              end
            else
              @output_file.write("#{policy_number}\n") # same number if hasn't error
            end
          end
          @output_file.close
        end
      end
    end
  end
end