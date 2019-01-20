require_relative '../../spec_helper'

describe Sorabji::StackOperation do
  describe "basic mathematical expressions" do

    let(:exp_left){ Sorabji::IntegerLiteral.new(125) }
    let(:exp_right){ Sorabji::IntegerLiteral.new(500) }
    let(:object){{
      1 => 125,
      2 => 500
    }}

    let(:expectations){{
      "+" => { result: 625 }, "*" => { result: 62500 }, "/" => { result: 0.25 }, "-" => { result: -375 }
    }}

    ['+', '*', '/', '-'].each do |operator|
      ["125#{operator}500", "125 #{operator}500", "125 #{operator} 500"].each do |example|
        describe "operation :: #{operator} #{example}" do
          let(:proc_object){ parse_to_proc(example) }
          specify "operation to_proc <#{example}>" do
            3.times do
              expect(proc_object.call(object)).to eq expectations[operator][:result]
            end
          end
        end
      end

      ["{1} #{operator} 500", "125 #{operator} {2}"].each do |example|
        specify "operation with lookup <#{example}>" do
          ast = parse(example).to_ast
          expect(ast.to_proc.call(object)).to eq expectations[operator][:result]
        end
      end
    end


    [
      ["125 + {2} + 10", 635, "compound addition"],
      ["125 + 500 * {2}", 125 + 500 * 500, "a nested operation"],
      ["(123 + 456) * {1}", (123+456)*125, "an operation with brackets"],
      ["(123 + 456)", (123 + 456), "an operation in brackets"],
      ["123 - 456 - 789", -1122, "subtraction operation order is left-right"],
      ["123 - 456 * 789 + 1011 * 2", (123 - (456 * 789) + (1011 * 2)), "multiple order-of-ops issues"]
    ].each do |example, expectation, description|
      specify description do
        r = parse(example).to_ast.to_proc
        3.times do
          expect(r.call(object)).to eq expectation
        end
      end
    end


    specify "a proc can be reused (operation stack is reset)" do
      parsed = parse("123 - 456 * 789 + 1011 * 2")
      ast = parsed.to_ast
      r = ast.to_proc
      a = r.call(object)
      b = r.call(object)
      expect(a).to eq b
    end

    [
      ['123-(456-789)', 456],
      ['(123-456)-789', -1122]
    ].each do |operation, expectation|
      specify "subtraction operation with brackets <#{operation}>" do
        expect(parse(operation).to_ast.to_proc.call(object)).to eq expectation
      end
    end
  end

  describe "automatic string conversion" do

    let(:data_object){ { 270 => "1958" } }
    let(:expression){ "2014 - {270}" }
    let(:sb_proc){ parse(expression).to_ast.to_proc }

    specify do
      expect(sb_proc.call(data_object)).to eq(2014 - 1958)
    end
  end
end
