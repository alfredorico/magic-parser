# Magic::Parser

A ruby library from parsing policy numbers generated for an ingenious machine purchased by Magic company.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'magic-parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magic-parser

## Usage

Having a text file _policy_numbers.txt_ (or whatever name) of unparsed policy numbers comming from ingenios marchine with the following content:
```txt
    _  _  _  _  _  _  _  _ 
|_||_   ||_ | ||_|| || || |    
  | _|  | _||_||_||_||_||_|    

 _  _     _  _        _  _ 
|_||_ |_| _|  |  ||_||_||_ 
|_||_|  | _|  |  |  | _| _|

 _  _        _     _  _  _ 
|_||_   |  || ||_||_| _||_ 
|_||_|  |  ||_|| ||   _||_|

```

In order to loading this file:
```ruby
file_loader = Magic::Parser::FileLoader.new(path_file: '/home/user/policy_numbers.txt')
file_loader.unformatted_numbers.class    # => Array
file_loader.unformatted_numbers.size     # => 3 (File contains three policy numbers)
file_loader.unformatted_numbers[0]       # => ["    _  _  _  _  _  _  _  _ ", "|_||_   ||_ | ||_|| || || |", "  | _|  | _||_||_||_||_||_|"]
file_loader.unformatted_numbers[0].size  # => 3 (Each number is an array of 3 strings)
puts file_loader.unformatted_numbers[0]
    _  _  _  _  _  _  _  _ 
|_||_   ||_ | ||_|| || || |
  | _|  | _||_||_||_||_||_|
puts file_loader.unformatted_numbers[1]
 _  _     _  _        _  _ 
|_||_ |_| _|  |  ||_||_||_ 
|_||_|  | _|  |  |  | _| _|
puts file_loader.unformatted_numbers[2]
 _  _        _     _  _  _ 
|_||_   |  || ||_||_| _||_ 
|_||_|  |  ||_|| ||   _||_|
```
For parsing a number comming from this file:
```ruby
number_parser = Magic::Parser::NumberParser.new(unparsed_policy_number: file_loader.unformatted_numbers[0])
number_parser.parsed_policy_number       # => "457508000" 

number_parser = Magic::Parser::NumberParser.new(unparsed_policy_number: file_loader.unformatted_numbers[1])
number_parser.parsed_policy_number       # => "864371495" 

number_parser = Magic::Parser::NumberParser.new(unparsed_policy_number: file_loader.unformatted_numbers[2])
number_parser.parsed_policy_number       # => "86110??36" if digit is not wellformed, then it's marked with ? 
```

For calculating a policy number checksum, if checksum is zero, the policy number is valid:
```ruby
checksum_calculator = Magic::Parser::ChecksumCalculator.new(policy_number: "457508000")
checksum_calculator.checksum             # => 0
checksum_calculator.checksum_code        # => nil
```
With an invalid policy number, checksum is non zero and code is ERR:
```ruby
checksum_calculator = Magic::Parser::ChecksumCalculator.new(policy_number: "437508010")
checksum_calculator.checksum             # => 8
checksum_calculator.checksum_code        # => "ERR"
```
With a non wellformed policy number like _86110??36_, character _?_ is interpreted as zero and code is ILL:
```ruby
checksum_calculator = Magic::Parser::ChecksumCalculator.new(policy_number: "86110??36")
checksum_calculator.checksum             # => 8
checksum_calculator.checksum_code        # => "ILL"
```

For writing parsed numbers to a file with checksum codes:
```ruby
file_loader = Magic::Parser::FileLoader.new(path_file: '/home/user/policy_numbers.txt')
output_file_path = '/home/user/policy_numbers_result.txt'
parsed_policy_numbers = file_loader.unformatted_numbers.inject([]) {|parsed_numbers, unformatted_policy_number| parsed_numbers << Magic::Parser::NumberParser.new(unparsed_policy_number: unformatted_policy_number).parsed_policy_number  }
checksum_code_writer = Magic::Parser::ChecksumCodeWriter.new(file_path: output_file_path, policy_numbers: parsed_policy_numbers)
checksum_code_writer.write_file
```
File _/home/user/policy_numbers_result.txt_ contains:
```
457508000
864371495 ERR
86110??36 ILL
```

Given invalid policy number (with checksum code different from zero), as this one:
```ruby
checksum_calculator = Magic::Parser::ChecksumCalculator.new(policy_number: "864371495")
checksum_calculator.checksum                 # => 9
checksum_calculator.checksum_code            # => "ERR"
```
It could be possible to guess a valid policy number as follows: 
```ruby
checksum_guesser = Magic::Parser::ChecksumGuesser.new(invalid_policy_number: "864371495")
checksum_guesser.policy_numbers_guessed      # => ["869371495", "864377495"]
```
And we can verifiy any of those numbers:
```ruby
Magic::Parser::ChecksumCalculator.new(policy_number: "869371495").checksum    # => 0
Magic::Parser::ChecksumCalculator.new(policy_number: "864377495").checksum    # => 0
```

Suppose that we have a file _parsed_codes.txt_ with invalid policy numbers (and valid numbers too) as this one:
```txt
664371495 ERR
457508000
345862865 ERR
87100??36 ILL
457608000 ERR
457608999 ERR
457908000 ERR
```
It is possible to create a guessed policy number file from the invalid policy numbers marked with code 'ERR' as follows (numbers marked as 'ILL' are not considered):
```ruby
checksum_guesser_writer = Magic::Parser::ChecksumGuesserWriter.new(input_file_path: '/home/user/parsed_codes.txt', output_file_path: '/home/user/guessed_codes.txt')
checksum_guesser_writer.write_guessed_policy_codes
```
If an invalid policy number has more than one guessed valid policy number, it's marked as AMB and just first guessed number is included. The _guessed_codes.txt_ contains:
```txt
664371485
457508000
945862865 AMB
87100??36 ILL
457508000 AMB
457608999 ILL
457508000
```
If it is impossible to guess a policy number, then it's marked as ILL. 

## Dependencies

Ruby versions officially supported and tested:
<ul>
<li>Ruby (MRI) 2.6.0+</li>
</ul> 

## Development

After checmagicg out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alfredorico/magic-parser.
