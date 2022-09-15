module Magic
  module Parser
    class NumberParser

      def initialize(unparsed_policy_number:)
        @unparsed_policy_number = unparsed_policy_number
      end

      def parsed_policy_number
        unless @parsed_policy_number
          @parsed_policy_number = ""
          (1..9).each do |digit_position|
            @parsed_policy_number << extract_digit(digit_position: digit_position)
          end
        end
        @parsed_policy_number
      end

      private
      def extract_digit(digit_position:)
        character_number = ""
        (0..2).each do |i|
          character_number << triple_group(digit_position: digit_position, line: @unparsed_policy_number[i])
        end
        DIGIT_MATCHER[character_number] || '?'
      end

      def triple_group(digit_position:, line:)
        line.split(//).each_slice(3).to_a[digit_position-1].join  
      end

    end
  end  
end