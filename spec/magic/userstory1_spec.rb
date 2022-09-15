RSpec.describe "User Story 1" do
  context Magic::Parser::NumberParser, "Parsing policy numbers" do
    let!(:unparsed_valid_policy_number1) { 
      [ " _     _  _  _  _  _  _  _ ", 
        " _||_||_ |_||_| _||_||_ |_ ", 
        " _|  | _||_||_||_ |_||_| _|"] 
    } 
    let!(:unparsed_valid_policy_number2) { 
      [ "    _  _  _  _  _  _  _  _ ", 
        "|_||_   ||_ | ||_|| || || |", 
        "  | _|  | _||_||_||_||_||_|"] 
    } 
    let!(:unparsed_ill_policy_number) { 
      [ "    _     _  _  _  _  _  _ ", 
        "|_||_ | ||_ | | _|| ||  | |", 
        "  | _|  | _||_||_||_||_ |_|  "] 
    } 
    let!(:number_parser1) { Magic::Parser::NumberParser.new(unparsed_policy_number: unparsed_valid_policy_number1) } 
    let!(:number_parser2) { Magic::Parser::NumberParser.new(unparsed_policy_number: unparsed_valid_policy_number2) } 
    let!(:number_parser3) { Magic::Parser::NumberParser.new(unparsed_policy_number: unparsed_ill_policy_number) } 

    it "parse valid policy numbers" do
      expect(number_parser1.parsed_policy_number).to be_an_instance_of(String)
      expect(number_parser1.parsed_policy_number).to eq("345882865")  
      expect(number_parser2.parsed_policy_number).to be_an_instance_of(String)
      expect(number_parser2.parsed_policy_number).to eq("457508000")  
    end

    it "parse illegible policy numbers" do
      expect(number_parser3.parsed_policy_number).to be_an_instance_of(String)
      expect(number_parser3.parsed_policy_number).to eq("45?50?0?0")  
    end

  end

  context Magic::Parser::FileLoader, "Extracting policy numbers from File" do
    context "a file with wellformed unformatted policy numbers" do
      let!(:file_loader) { Magic::Parser::FileLoader.new(path_file: './spec/magic/policy_numbers_2.txt') }
      it "extract each unformatted policy number from file in an array of arrays" do
        expect(file_loader.unformatted_numbers).to be_an_instance_of(Array)
        file_loader.unformatted_numbers.each do |unformatted_number|
          expect(unformatted_number).to be_an_instance_of(Array)
        end
      end

      it "extract and cleaning properly each unformatted policy number" do
        expect(file_loader.unformatted_numbers[0]).to eq(
          [
            " _     _  _  _  _  _  _  _ ", 
            " _||_||_ |_||_| _||_||_ |_ ", 
            " _|  | _||_||_||_ |_||_| _|"
          ]            
        ) 
        expect(file_loader.unformatted_numbers[1]).to eq(
          [
            "    _  _  _  _  _  _  _  _ ", 
            "|_||_   ||_ | ||_|| || || |", 
            "  | _|  | _||_||_||_||_||_|"
          ]                       
        ) 
      end        


    end

    context "a file with non wellformed unformatted policy numbers" do
      let!(:file_loader1) { Magic::Parser::FileLoader.new(path_file: './spec/magic/policy_numbers_not_wellformed1.txt') }
      let!(:file_loader2) { Magic::Parser::FileLoader.new(path_file: './spec/magic/policy_numbers_not_wellformed2.txt') }
      it "raise an exception if a line doesn't have 27 characters for a valid unformatted policy number" do
        expect {file_loader1.unformatted_numbers}.to raise_error(Magic::Parser::FileLoaderError, /WRONG NUMBER OF CHARACTERS IN FILE/)
      end
      it "raise an exception if a line contains character different from | _ or white space" do
        expect {file_loader2.unformatted_numbers}.to raise_error(Magic::Parser::FileLoaderError, /NOT ALLOWED CHARACTER IN FILE/)
      end
    end

  end
end

=begin
Numero del archivo: 345882865
checksum: 0
-------------------------
Numero del archivo: 457508000
=end