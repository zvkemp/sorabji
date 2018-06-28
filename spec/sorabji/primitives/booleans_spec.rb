require_relative '../../spec_helper'

describe Sorabji::Boolean do
  specify do
    expect(parse('true').to_ast.to_proc.call({})).to eq true
  end

  specify do
    expect(parse('false').to_ast.to_proc.call({})).to eq false
  end

  describe "comparisons" do
    [
      ["1 > 2", false],
      ["1<2", true],
      ["1 <= 2", true],
      ["1 >= 2", false],
      ["1 == 2", false],
      ["1 == 1", true],
      ["1 >= 1", true],
      ["1 <= 1", true],
      ["1 < {276}", true],
      ["1 > {276}", false]
    ].each do |example, expectation|
      specify "comparison #{example}" do
        expect(parse(example).to_ast.to_proc.call({ 276 => 2 })).to eq expectation
      end
    end
  end
end

