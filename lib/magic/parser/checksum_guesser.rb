module Magic
  module Parser
    class ChecksumGuesser

      def initialize(invalid_policy_number:)
        @invalid_policy_number = invalid_policy_number
        @array_invalid_policy_number = @invalid_policy_number.scan(/\d/) 
      end
      
      def policy_numbers_guessed
        return [] if @invalid_policy_number.include?('?')
        return [] if calculate_checksum(@invalid_policy_number) == 0
        unless @alternative_valid_policy_numbers
          @alternative_valid_policy_numbers = []
          @array_invalid_policy_number.each_with_index do |digit, i|
            digit_alternatives[digit].each do |digit_alternative|
              policy_number = @array_invalid_policy_number.dup
              policy_number[i] = digit_alternative
              policy_number = policy_number.join
              @alternative_valid_policy_numbers << policy_number if calculate_checksum(policy_number) == 0
            end
          end
          return [] if @alternative_valid_policy_numbers.empty?
        end
        @alternative_valid_policy_numbers
      end

      private
      def calculate_checksum(policy_number)
        Magic::Parser::ChecksumCalculator.new(policy_number: policy_number).checksum
      end

      def digit_alternatives
        {
          '0' => ['8'],
          '1' => ['7'],
          '2' => [],
          '3' => ['9'],
          '4' => ['9'],
          '5' => ['9','6'],
          '6' => ['5','8'],
          '7' => ['1'],
          '8' => ['9','6','0'],
          '9' => ['8','5','3']
        }        
      end 

    end
  end
end