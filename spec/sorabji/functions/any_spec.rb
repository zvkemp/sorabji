require_relative '../../spec_helper'

describe Sorabji::FunctionAny do
  [
    [ %<any?{276}>, { 276 => 10 }, true, 'single value a' ],
    [ %<any?[{276}]>, { 276 => 9 }, true, 'single value b' ],
    [ %<any?[]>, {}, false, 'no values present'],
    [ %<any?[{276}]>, { 276 => [1, 2, 3]}, true, 'array values'],
    [ %<any?{276}>, { 276 => [1, 2, 3]}, true, 'array values 2'],
    [ %<any?{276}>, { 276 => []}, false, 'empty array'],
    [ %<any?{276}>, { 276 => nil}, false, 'nil value'],
    [ %<any?{276 277}>, { 276 => nil, 277 => nil}, false, 'nil values'],
    [ %<any?{276 277}>, { 276 => nil, 277 => []}, false, 'nil values 2'],
    [ %<any?{276 277}>, { 276 => nil, 277 => [1]}, true, 'some values'],
    [ %<any?[{276} {277}]>, { 276 => nil, 277 => [1]}, true, 'some values 2'],
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify do
        expect(function.call(object)).to eq expectation
      end
    end
  end
end
