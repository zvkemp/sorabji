require_relative '../../spec_helper'

describe Sorabji::FunctionMean do
  let(:object){{ 101 => 10, 103 => 40 }}

  [
    ['mean[10 20 30]', 20, 'basic'],
    ['mean[{101} 20 30]', 20, 'with lookups'],
    ['mean[{102} 20 30]', 25, 'ignores missing values'],
    ['mean[]', nil, 'nil for an empty list'],
    ['mean{101 102 103}', 25, 'ident list']
  ].each do |example, expectation, desc|
    describe desc do
      let(:ast){ parse(example).to_ast }
      let(:function){ ast.to_proc }

      specify { function.call(object).must_equal expectation }
    end
  end
end
