require_relative '../../spec_helper'

describe "Sorabji::Nested Functions" do
  before {
    Sorabji::config.reference_object_method = :reference_object
  }

  let(:expression){ %{default[{101} {102} if[{276} ({{year}} - {276}) {{year}}]]} }
  let(:ast){ parse(expression).to_ast }
  let(:function){ ast.to_proc }
  let(:ref){ OpenStruct.new(year: 2014) }

  [
    [{ 101 => :hello, 102 => :world, 276 => 1984 }, :hello, 'default catch 1'],
    [{ 102 => :world, 276 => 1984 }, :world, 'default catch 2'],
    [{ 276 => 1984 }, 30, 'ternary true'],
    [{ }, 2014, 'ternary false']
  ].each do |object, expectation, desc|
    describe desc do
      before { stub(object).reference_object { ref }}
      specify { function.call(object).must_equal expectation }
    end
  end
end
