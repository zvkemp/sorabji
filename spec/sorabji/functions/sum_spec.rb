require_relative '../../spec_helper'

describe Sorabji::FunctionSum do

  [
    [%<sum[1 2 3]>, {}, 6, 'simple sum'],
    [%<sum[]>, {}, 0, 'no values given'],
    [%<sum[{276} {277}]>, { 276 => 10 }, 10, 'nil values present']
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify { function.call(object).must_equal expectation }
    end
  end
end

