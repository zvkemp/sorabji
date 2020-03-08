require_relative '../../spec_helper'

describe Sorabji::ListFunction do
  [
    ['union[123][456 789]', {}, [123, 456, 789], 'simple union'],
    ['difference[100 99 98][99]', {}, [100, 98], 'simple difference'],
    ['difference{101}[1]', {}, [], 'missing value difference'],
    ['join[100 101][100 102]', {}, [100, 101, 100, 102], 'simple join'],
    ['intersect[100 101 102][101 102 103]', {}, [101, 102], 'simple intersect'],
    ['difference{101 102}[99]', { 101 => 1, 102 => 99 }, [1], 'difference with lookup'],

    ["has_any?{101}[101 102 103]", { 101 => [10, 5, 0] }, false, "has_any? no match"],
    ["has_any?{101}[101 102 103]", { 101 => [101, 105, 110] }, true, "has_any? one match"],
    ["has_any?{101 102}[101 102 103]", { 101 => [10, 5, 0], 102 => 101 }, true, "has_any? one compound match"],
    ["has_any?{101 102}[101 102 103]", { 101 => [102, 5, 0], 102 => 101 }, true, "has_any? two compound matches"],

    ["has_all?{101}[101 102 103]", { 101 => [101, 105, 110] }, false, "has_all? one match"],
    ["has_all?{101}[101 102 103]", { 101 => [101, 102, 103, 105, 110] }, false, "has_all? all match"],
    ["has_all?{101 102}[101 102 103]", { 101 => [101, 103, 105, 110], 102 => 102 }, false, "has_all? all match (compound keys)"],

  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify do
        expect(function.call(object)).to eq expectation
      end
    end
  end
end
