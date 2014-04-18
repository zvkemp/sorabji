require_relative '../../spec_helper'

describe Sorabji::FunctionConcat do
  [
    [%{concat[101 102 ";"]}, {}, "101;102", %{simple values}],
    [%{concat[present{101 102 103} "; "]}, { 101 => "yes", 103 => "present" }, "yes; present", %{missing lookup}],
    [%{concat[{101} {102} "; "]}, {}, "", %{2 missing lookups}],
    [%{concat[{101 102} "; "]}, {}, "", %{2 missing lookups 2}],
    [%{concat[present{101 102} "; "]}, {}, "", %{2 missing lookups 3}]
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify { function.call(object).must_equal expectation }
    end
  end

end
