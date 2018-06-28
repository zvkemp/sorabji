require_relative '../../spec_helper'

describe Sorabji::ListFunction do
  [
    ['union[123][456 789]', {}, [123, 456, 789], 'simple union'],
    ['difference[100 99 98][99]', {}, [100, 98], 'simple difference'],
    ['difference{101}[1]', {}, [], 'missing value difference'],
    ['join[100 101][100 102]', {}, [100, 101, 100, 102], 'simple join'],
    ['intersect[100 101 102][101 102 103]', {}, [101, 102], 'simple intersect'],
    ['difference{101 102}[99]', { 101 => 1, 102 => 99 }, [1], 'difference with lookup']
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify do
        expect(function.call(object)).to eq expectation
      end
    end
  end
end
