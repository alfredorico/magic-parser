RSpec.describe "User Story 4" do
  context Magic::Parser::ChecksumGuesser, "To guess a policy number marked as ERR" do
    it "return an array of guessed valid policy numbers if given an invalid policy_number" do
      # return multiple guessed numbers
      @checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: "345862865")
      expect(@checksum_guesser.policy_numbers_guessed).to include("945862865", "345662865", "345882865")

      @checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: "457608000")
      expect(@checksum_guesser.policy_numbers_guessed).to include("457508000", "457608080")
      
      # return at least one guessed number
      @checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: "664371495")
      expect(@checksum_guesser.policy_numbers_guessed).to include("664371485")
      
      @checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: "457508080")
      expect(@checksum_guesser.policy_numbers_guessed).to include("457508000")
    end

    it "return an empty array, if it is already a valid policy number" do
      @valid_policy_number = "345882865"
      @checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: @valid_policy_number)
      expect(@checksum_guesser.policy_numbers_guessed).to be_empty      
    end

    it "return an empty array if no guessed number has found" do
      @invalid_policy_number = "355882962"
      @checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: @invalid_policy_number)
      expect(@checksum_guesser.policy_numbers_guessed).to be_empty      
    end    

    it "return an empty array if a illegible policy number is provided" do
      @ill_policy_number = "87100??36"
      @checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: @ill_policy_number)
      expect(@checksum_guesser.policy_numbers_guessed).to be_empty
    end    
    
  end

  context Magic::Parser::ChecksumGuesserWriter, "for writing to a file, guessed a policy number marked from original file as ERR" do
    it "generate an alternative file replacing original policy number marked as ERR with guessed policy numbers if possible" do
      output_file_path = './spec/magic/checksum_codes_guessed.txt'
      checksum_guesser_writer = Magic::Parser::ChecksumGuesserWriter.new(input_file_path: './spec/magic/checksum_failed_codes.txt', output_file_path: output_file_path)
      checksum_guesser_writer.write_guessed_policy_codes
      file_content = File.open(output_file_path).read
      expect(file_content).to eq("457508000\n664371485\n945862865 AMB\n87100??36 ILL\n457508000 AMB\n457608999 ILL\n457508000\n")
    end

  
  end

end

=begin
457508000
664371485
345882865
87100??36 ILL
457508000
457508000
=end