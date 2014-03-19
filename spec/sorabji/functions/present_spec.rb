require_relative '../../spec_helper'

describe Sorabji::FunctionPresent do
  [
    [%{present[101 false {102} {103}]}, {}, [101], "false with lookups"],
    [%{present[101 102 103]}, {}, [101, 102, 103], "simple values"],
    [%{present{101 102 103}}, { 101 => :hello, 103 => :world }, [:hello, :world], "simple lookups"],
    [%{present{101 102}}, { 101 => " ", 102 => "not empty" }, ["not empty"], "empty strings"]
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify { function.call(object).must_equal expectation }
    end
  end
end
