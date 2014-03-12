require_relative '../spec_helper'
require 'rr'
require 'ostruct'

describe Sorabji::Parser do
  specify { parser.wont_be_nil }
  specify { parser.must_be_instance_of SorabjiParser }

  describe 'errors' do
  end

  describe 'simple expressions' do
    specify "parsing an integer" do
      parse_tree = parse('123')
      parse_tree.to_ast.must_equal [Sorabji::IntegerLiteral.new(123)]
    end

    specify "object identifier" do
      parse_tree = parse '{123}'
      parse_tree.to_ast.must_equal [Sorabji::ObjectIdentifier.new(123)]
    end

    specify "identifier" do
      parse_tree = parse 'external_id'
      # not a valid script
      ->{ parse_tree.to_ast }.must_raise NoMethodError
    end

    specify "object symbol ident" do
      parse_tree = parse '{external_id}'
      parse_tree.to_ast.must_equal [Sorabji::ObjectIdentifier.new(:external_id)]
    end

    specify "reference object symbol ident" do
      parse_tree = parse '{{year}}'
      parse_tree.to_ast.must_equal [Sorabji::ReferenceObjectIdentifier.new(:year)]
    end

    ['+', '-', '/', '*'].each do |operator|
      specify "operator #{operator}" do
        parse_tree = parse operator 
        -> { parse_tree.to_ast }.must_raise NoMethodError
      end
    end

    specify "brackets" do
      parse_tree = parse '(123)'
      parse_tree.to_ast.must_equal [Sorabji::Bracketed.new(Sorabji::IntegerLiteral.new(123))]
    end
  end

  describe "basic mathematical expressions" do
    let(:exp_left){ Sorabji::IntegerLiteral.new(125) }
    let(:exp_right){ Sorabji::IntegerLiteral.new(500) }
    let(:object){{
      1 => 125,
      2 => 500
    }}

    let(:expectations){{
      "+" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:+)),
        result: 625
      }, "*" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:*)),
        result: 62500
      }, "/" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:/)),
        result: 0.25
      }, "-" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:-)),
        result: -375
      }
    }}

    ['+', '*', '/', '-'].each do |operator|
      ["125#{operator}500",
       "125 #{operator}500",
       "125 #{operator} 500"].each do |example|
        specify "operation <#{example}>" do
          ast = parse(example).to_ast[0]
          ast.must_equal expectations[operator][:expression]
        end

        specify "operation to_proc <#{example}>" do
          ast = parse(example).to_ast[0]
          ast.to_proc.call(object).must_equal expectations[operator][:result]
        end
      end

      ["{1} #{operator} 500", "125 #{operator} {2}"].each do |example|
        specify "operation with lookup <#{example}>" do
          ast = parse(example).to_ast[0]
          ast.to_proc.call(object).must_equal expectations[operator][:result]
        end
      end
    end

    specify "compound addition" do
      ast = parse("125 + {2} + 10").to_ast[0]
      ast.to_proc.call(object).must_equal 635
    end

    specify "a nested operation" do
      ast = parse("125 + 500 * {2}").to_ast[0]
      ast.to_proc.call(object).must_equal 125 + 500 * 500
    end

    specify "an operation with brackets" do
      ast = parse("(123 + 456) * {1}").to_ast[0]
      ast.to_proc.call(object).must_equal (123+456)*125
    end

    specify "an operation in brackets" do
      ast = parse("(123 + 456)").to_ast[0]
      ast.to_proc.call(object).must_equal (123 + 456)
    end

    specify "subtraction operation order is left-right" do
      ast = parse("123 - 456 - 789").to_ast[0]
      ast.to_proc.call(object).must_equal -1122
    end

    [
      ['123-(456-789)', 456],
      ['(123-456)-789', -1122]
    ].each do |operation, expectation|
      specify "subtraction operation with brackets <#{operation}>" do
        parse(operation).to_ast[0].to_proc.call(object).must_equal expectation
      end
    end

  end

  describe 'to_proc' do
    let(:object){{
      external_id: 1001,
      123 => :hello,
      124 => :world,
      201 => 6,
      202 => 9
    }}

    let(:reference_object){ OpenStruct.new(year: 2014) }
    specify 'basic integer' do
      ast = parse('123').to_ast[0]
      ast.to_proc.call(:anything, :at, :all).must_equal 123
    end

    specify "object identifier integer" do
      ast = parse('{123}').to_ast[0]
      ast.to_proc.call(object).must_equal :hello
    end

    specify "object identifier symbol" do
      ast = parse('{external_id}').to_ast[0]
      ast.to_proc.call(object).must_equal 1001
    end

    specify "identifier" do
      ast = parse('external_id')
      -> { ast.to_ast[0].to_proc.call(:anything, :at, :all) }.must_raise NoMethodError
    end

    specify "reference object identifier" do
      stub(object).reference_object { reference_object }
      ast = parse('{{year}}').to_ast[0]
      ast.to_proc.call(object).must_equal 2014
    end

    specify "brackets" do
      ast = parse('({123})').to_ast[0]
      ast.to_proc.call(object).must_equal :hello
    end


    describe 'lists' do
      specify 'empty list' do
        parsed = parse('[]')
        ast = parsed.to_ast[0]
        ast.must_be_instance_of Sorabji::List
        ast.must_equal Sorabji::List.new([])
      end

      specify 'one element' do
        parsed = parse '[123]'
        ast = parsed.to_ast[0]
        ast.must_equal Sorabji::List.new([Sorabji::IntegerLiteral.new(123)])
      end

      specify "multiple elements" do
        parsed = parse('[123 456 789]')
        ast = parsed.to_ast[0]
        ast.to_proc.call({}).must_equal [123, 456, 789]
      end

      specify "with lookups" do
        parsed = parse('[123 456 {276}]')
        ast = parsed.to_ast[0]
        ast.to_proc.call({ 276 => 2 }).must_equal [123, 456, 2]
      end

      specify "with operations" do
        parsed = parse('[123 ({276} * 10)]')
        ast = parsed.to_ast[0]
        ast.to_proc.call({ 276 => 2 }).must_equal [123, 20]
      end

      specify "nested" do
        parsed = parse('[123 [456 789]]')
        ast = parsed.to_ast[0]
        ast.to_proc.call({}).must_equal [123, [456, 789]]
      end
    end
  end

  describe "named functions" do
    describe "default" do
      let(:expression){ "default[{276} {275} 101]" }

      specify "returns the first present value in the arguments list" do
        ast = parse(expression).to_ast[0]
        function = ast.to_proc
        function.call({ 101 => 2 }).must_equal 101
        function.call({ 275 => 15 }).must_equal 15
        function.call({ 276 => 3 }).must_equal 3
      end
    end

    describe "ternary" do
      # should implement boolean expressions, comparisons
      #
      let(:args){'[{276} ({276} + 1) 1000]' }
      let(:expression){ "if#{args}" }

      specify "it works like a ternary operator" do
        ast = parse(expression).to_ast[0]
        function = ast.to_proc
        function.call({ 276 => 7 }).must_equal 8
        function.call({ }).must_equal 1000
        function.call({ 276 => false }).must_equal 1000
      end
    end

    describe "nested functions" do
      let(:ref){ OpenStruct.new(year: 2014) }

      let(:expression){ %{default[{101} {102} if[{276} ({{year}} - {276}) {{year}}]]} }
      let(:function){ parse(expression).to_ast[0].to_proc }
      [
        [{ }, 2014],
        [{ 276 => 10 }, 2004],
        [{ 102 => 11 }, 11]
      ].each do |obj, exp|
        specify do
          stub(obj).reference_object { ref }
          function.call(obj).must_equal exp
        end
      end
    end
  end

  describe 'dashboard examples' do
    let(:obj){{
      276 => 5,
      280 => 4,
      103 => 2
    }}

    let(:reference){ OpenStruct.new(year: 2013) }

    before { stub(obj).reference_object { reference } }

    [
      ["r[276]", "{276}", 5],
      ["2013 - r[276]", "2013 - {276}", 2008],
      ["year - r[276]", "{{year}} - {276}", 2008],
      ["5369", "5369", 5369],
      ["r[276] * r[280]", "{276} * {280}", 20],
      ["r[276] / r[280]", "{276} / {280}", 1.25],
      ["r[101] || r[102] || r[103]", "default[{101} {102} {103}]", 2]
    ].each do |old_style, new_style, expectation|
      specify(old_style) do
        ast = parse(new_style).to_ast[0]
        ast.to_proc.call(obj).must_equal expectation
      end
    end
  end
end
