require_relative '../../spec_helper'

describe Sorabji::Boolean do
  specify { parse('true').to_ast.to_proc.call({}).must_equal true }
  specify { parse('false').to_ast.to_proc.call({}).must_equal false }

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
        parse(example).to_ast.to_proc.call({ 276 => 2 }).must_equal expectation
      end
    end
  end
end

