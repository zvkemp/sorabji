require_relative '../../spec_helper'

describe Sorabji::FunctionIncluded do
  [
    [ %<included?[10 {276}]>, { 276 => 10 }, true, 'single value match' ],
    [ %<included?[10 {276}]>, { 276 => 9 }, false, 'single value no match' ],
    [ %<included?[10 {276}]>, {}, false, 'no values present'], 
    [ %<included?[10 {276}]>, { 276 => [1, 2, 3]}, false, 'array values, exp not present'],
    [ %<included?[10 {276}]>, { 276 => [8, 9, 10, 11]}, true, 'array values, exp present'],
    [ %<included?[10 {276}]>, { 276 => "hello"}, false, 'string format'],
    [ %<included?[10 [8 9 10 11]]>, {}, true, 'literal list'],
    [ %<included?[10 [{276} 9 8 7]]>, { 276 => 10 }, true, 'list interpolation']
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify { function.call(object).must_equal expectation }
    end
  end
end
