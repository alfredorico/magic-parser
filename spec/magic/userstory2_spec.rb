RSpec.describe "User Story 2" do
  context Magic::Parser::ChecksumCalculator, "Calculating policy number checksum" do
    let(:checksum_calculator1) { Magic::Parser::ChecksumCalculator.new(policy_number: "345882865") }
    let(:checksum_calculator2) { Magic::Parser::ChecksumCalculator.new(policy_number: "457508000") }
    let(:checksum_calculator3) { Magic::Parser::ChecksumCalculator.new(policy_number: "657508010") }
    it "calculates checksum to 0 when policy number is valid" do
      expect(checksum_calculator1.checksum).to eq(0) 
      expect(checksum_calculator2.checksum).to eq(0) 
    end

    it "calculates checksum to non 0 when policy number is invalid" do
      expect(checksum_calculator3.checksum).to_not eq(0) 
    end
    
  end
end