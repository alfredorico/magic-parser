module Magic
  module Parser
    class ChecksumCalculator

      def initialize(policy_number:)
        @policy_number = policy_number
      end

      def checksum
        @checksum ||= @policy_number.reverse.split(//).map{|x| x.to_i }.each_with_index.inject(0) {|sum, (digit,i)| (i+1)*digit + sum } % 11
      end

      def checksum_code
        return 'ILL' if @policy_number.include?('?')
        checksum == 0 ? nil : 'ERR'
      end      

    end
  end
end