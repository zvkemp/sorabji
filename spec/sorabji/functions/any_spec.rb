require_relative '../../spec_helper'

describe 'any/empty' do
  EXAMPLES = [
    [ %<%s?{276}>, { 276 => 10 }, true, 'single value a' ],
    [ %<%s?[{276}]>, { 276 => 9 }, true, 'single value b' ],
    [ %<%s?[]>, {}, false, 'no values present'],
    [ %<%s?[{276}]>, { 276 => [1, 2, 3]}, true, 'array values'],
    [ %<%s?{276}>, { 276 => [1, 2, 3]}, true, 'array values 2'],
    [ %<%s?{276}>, { 276 => []}, false, 'empty array'],
    [ %<%s?{276}>, { 276 => nil}, false, 'nil value'],
    [ %<%s?{276 277}>, { 276 => nil, 277 => nil}, false, 'nil values'],
    [ %<%s?{276 277}>, { 276 => nil, 277 => []}, false, 'nil values 2'],
    [ %<%s?{276 277}>, { 276 => nil, 277 => [1]}, true, 'some values'],
    [ %<%s?[{276} {277}]>, { 276 => nil, 277 => [1]}, true, 'some values 2'],
  ]

  describe Sorabji::FunctionAny do
    EXAMPLES.each do |example, object, expectation, desc|
      describe desc do
        let(:function){ parse(example % 'any').to_ast.to_proc }
        specify do
          expect(function.call(object)).to eq expectation
        end
      end
    end
  end

  describe Sorabji::FunctionEmpty do
    EXAMPLES.each do |example, object, expectation, desc|
      describe desc do
        let(:function){ parse(example % 'empty').to_ast.to_proc }
        specify do
          expect(function.call(object)).to eq !expectation
        end
      end
    end
  end
end
