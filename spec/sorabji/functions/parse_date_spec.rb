require_relative '../../spec_helper'

describe Sorabji::FunctionParseDate do
  format_string = "%A, %B %d, %Y %l:%M %p"

  [
    [%{parse_date[{101} "#{format_string}"]}, { 101 => "Tuesday, January 10, 1984 8:45 PM" }, nil, "date, month, day, year"]
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify { function.call(object).must_equal Time.new(1984, 1, 10, 20, 45) }
    end
  end
end
