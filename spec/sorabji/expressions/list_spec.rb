require_relative '../../spec_helper'

describe Sorabji::List do
  let(:object){ { 101 => 789 } }

  [
    [   '[]',    [],     'empty list'],
    ['[123]', [123], 'single element'],
    ['[123 456 789]', [123, 456, 789], 'multiple elements'],
    ['[123 456 {101}]', [123, 456, 789], 'with lookups'],
    ['[123 ({101} * 10)]', [123, 7890], 'with operations'],
    ['[123 [456 [{101}]]]', [123, [456, [789]]], 'nested']
  ].each do |example, expectation, desc|
    describe desc do
      let(:ast){ parse(example).to_ast }
      specify("#{desc} to_proc"){ ast.to_proc.call(object).must_equal expectation }
    end
  end
end
