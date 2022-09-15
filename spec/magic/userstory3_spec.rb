RSpec.describe "User Story 3" do
  context Magic::Parser::ChecksumCalculator, "Calculating checksum code" do
    let!(:checksum_calculator1) { Magic::Parser::ChecksumCalculator.new(policy_number: "457508000") }
    let!(:checksum_calculator2) { Magic::Parser::ChecksumCalculator.new(policy_number: "664371495") }
    let!(:checksum_calculator3) { Magic::Parser::ChecksumCalculator.new(policy_number: "86110??36") }
    it "calculates checksum code to nil when policy number is valid" do
      expect(checksum_calculator1.checksum_code).to be_nil 
    end
    it "calculates checksum code to ERR when policy number is invalid" do
      expect(checksum_calculator2.checksum_code).to eq('ERR') 
    end
    it "calculates checksum code to ILL when policy number is illegible" do
      expect(checksum_calculator3.checksum_code).to eq('ILL')
    end        
  end

  context Magic::Parser::ChecksumCodeWriter, "Writing to file policy number checksum codes" do
    before(:all) do
      @file_path = './spec/magic/checksum_codes.txt'
      @policy_numbers = ['457508000','664371495','87100??36']
      @checksum_code_writer = Magic::Parser::ChecksumCodeWriter.new(file_path: @file_path, policy_numbers: @policy_numbers)
      @checksum_code_writer.write_file
    end

    it "generates a checksum code file with the same quantity of lines as policy_numbers indicated" do
      count = 0; 
      File.foreach(@file_path){ count+=1}; # The fastes benchmark way for counting a file (thinmagicg of thousand of policy numbers)
      expect(count).to eq(@policy_numbers.size)        
    end

    it "generates a checksum code file which every line has two colums (blank space separated) for ERR or ILL checksum codes" do
      File.open(@file_path).each do |line|
        expect(line.gsub("\n","")).to match(/(^\d+$)|(^\d+ ERR$)|(^(\?|\d)+ ILL$)/)
      end
    end
       
  end
end

