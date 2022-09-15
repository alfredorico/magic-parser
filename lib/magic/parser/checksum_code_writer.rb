module Magic
  module Parser
    class ChecksumCodeWriter

      def initialize(policy_numbers:, file_path:)
        @policy_numbers = policy_numbers
        @file_path = file_path
      end

      def write_file
        File.open(@file_path, 'w') do |file|
          @policy_numbers.each do |policy_number|
            checksum_calculator = ChecksumCalculator.new(policy_number: policy_number)
            if checksum_calculator.checksum_code
              file.write("#{policy_number} #{checksum_calculator.checksum_code}\n")
            else
              file.write("#{policy_number}\n")
            end
          end
        end
      end

    end
  end
end