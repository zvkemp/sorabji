require_relative '../../spec_helper'

describe Sorabji::Bracketed do
  [
    ['(123)', Sorabji::IntegerLiteral.new(123), 'one level'],
    ['((123))', Sorabji::Bracketed.new(Sorabji::IntegerLiteral.new(123)), 'two levels']
  ].each do |example, expectation, desc|
    describe desc do
      let(:ast){ parse(example).to_ast }

      specify do
        expect(ast).to eq Sorabji::Bracketed.new(expectation)
      end

      specify("to_proc") do
        expect(ast.to_proc.call(Object.new)).to eq 123
      end
    end
  end
end
