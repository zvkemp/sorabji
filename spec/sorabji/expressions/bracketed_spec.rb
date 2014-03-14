require_relative '../../spec_helper'

describe Sorabji::Bracketed do
  [
    ['(123)', Sorabji::IntegerLiteral.new(123), 'one level'],
    ['((123))', Sorabji::Bracketed.new(Sorabji::IntegerLiteral.new(123)), 'two levels']
  ].each do |example, expectation, desc|
    describe desc do
      let(:ast){ parse(example).to_ast }

      specify { ast.must_equal Sorabji::Bracketed.new(expectation) }
      specify("to_proc"){ ast.to_proc.call(Object.new).must_equal 123 }
    end
  end
end
