require_relative '../../spec_helper'

describe Sorabji::Operation do
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
          ast = parse(example).to_ast
          ast.must_equal expectations[operator][:expression]
        end

        specify "operation to_proc <#{example}>" do
          ast = parse(example).to_ast
          ast.to_proc.call(object).must_equal expectations[operator][:result]
        end
      end

      ["{1} #{operator} 500", "125 #{operator} {2}"].each do |example|
        specify "operation with lookup <#{example}>" do
          ast = parse(example).to_ast
          ast.to_proc.call(object).must_equal expectations[operator][:result]
        end
      end
    end

    specify "compound addition" do
      ast = parse("125 + {2} + 10").to_ast
      ast.to_proc.call(object).must_equal 635
    end

    specify "a nested operation" do
      ast = parse("125 + 500 * {2}").to_ast
      ast.to_proc.call(object).must_equal 125 + 500 * 500
    end

    specify "an operation with brackets" do
      ast = parse("(123 + 456) * {1}").to_ast
      ast.to_proc.call(object).must_equal (123+456)*125
    end

    specify "an operation in brackets" do
      ast = parse("(123 + 456)").to_ast
      ast.to_proc.call(object).must_equal (123 + 456)
    end

    specify "subtraction operation order is left-right" do
      ast = parse("123 - 456 - 789").to_ast
      ast.to_proc.call(object).must_equal -1122
    end

    [
      ['123-(456-789)', 456],
      ['(123-456)-789', -1122]
    ].each do |operation, expectation|
      specify "subtraction operation with brackets <#{operation}>" do
        parse(operation).to_ast.to_proc.call(object).must_equal expectation
      end
    end

  end
end
