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
    let(:exp_left){ Sorabji::IntegerLiteral.new(123) }
    let(:exp_right){ Sorabji::IntegerLiteral.new(456) }
    let(:object){{
      1 => 123,
      2 => 456
    }}

    let(:expectations){{
      "+" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:+)),
        result: 579
      }, "*" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:*)),
        result: 56088
      }, "/" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:/)),
        result: 0
      }, "-" => { 
        expression: Sorabji::Operation.new(exp_left, exp_right, Sorabji::Operator.new(:-)),
        result: -333
      }
    }}

    ['+', '*', '/', '-'].each do |operator|
      ["123#{operator}456",
       "123 #{operator}456",
       "123 #{operator} 456"].each do |example|
        specify "operation <#{example}>" do
          ast = parse(example).to_ast[0]
          ast.must_equal expectations[operator][:expression]
        end

        specify "operation to_proc <#{example}>" do
          ast = parse(example).to_ast[0]
          ast.to_proc.call(object).must_equal expectations[operator][:result]
        end
      end

      ["{1} #{operator} 456", "123 #{operator} {2}"].each do |example|
        specify "operation with lookup <#{example}>" do
          ast = parse(example).to_ast[0]
          ast.to_proc.call(object).must_equal expectations[operator][:result]
        end
      end
    end

    specify "compound addition" do
      ast = parse("123 + {2} + 10").to_ast[0]
      ast.to_proc.call(object).must_equal 589
    end

    specify "a nested operation" do
      ast = parse("123 + 456 * {2}").to_ast[0]
      ast.to_proc.call(object).must_equal 207936 + 123
    end

    specify "an operation with brackets" do
      ast = parse("(123 + 456) * {1}").to_ast[0]
      ast.to_proc.call(object).must_equal (123+456)*123
    end

    specify "an operation in brackets" do
      ast = parse("(123 + 456)").to_ast[0]
      ast.to_proc.call(object).must_equal (123 + 456)
    end

    specify "subtraction operation order is left-right" do
      ast = parse("123 - 456 - 789").to_ast[0]
      ast.to_proc.call(object).must_equal -1122
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
  end



end
