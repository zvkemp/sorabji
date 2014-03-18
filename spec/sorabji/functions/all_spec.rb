require_relative '../../spec_helper'

describe Sorabji::FunctionAll do

  [
    ["all[101 102 103]", { 101 => "", 102 => "yes", 103 => "maybe" }, true],
    ["all{101 102 103}", { 101 => "", 102 => "yes", 103 => "maybe" }, false],
    ["all{101 102 103}", { 101 => 1, 102 => 2, 103 => 3 },            true],
    ["all{101 102 103}", { 101 => :hello, 102 => " ", 103 => "3" },   false]
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify { function.call(object).must_equal expectation }
    end
  end

  describe "mixing functions" do
    specify 'within an if function' do
      function = parse(%{if[all{101 102} "yes" "no"]}).to_ast.to_proc
      function.call({ 101 => 2 }).must_equal 'no'
      function.call({ 101 => 2, 102 => 3 }).must_equal 'yes'
    end

    specify 'containing an if function' do
      function = parse(%{all[if[1 > 0 true false] true]}).to_ast.to_proc
      function.call({}).must_equal true
      function = parse(%{all[if[1 < 0 true false] true]}).to_ast.to_proc
      function.call({}).must_equal false
    end
  end
end

