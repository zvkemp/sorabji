require_relative '../../spec_helper'

describe "Sorabji::Identifier List" do
  describe "identifier list" do
    # {101 102 103 104 105} would be equivalent to
    # [{101} {102} {103} {104} {105}]
    specify "ident list" do
      function = parse("{101 102 103}").to_ast.to_proc
      expect(function.call({ 101 => 1, 102 => 2 })).to eq [1, 2, nil]
    end

    # sum{101 102 103}
    # sum[{101} {102} {103}]
    specify "function called with ident list" do
      function = parse("sum{101 102 103}").to_ast.to_proc
      expect(function.call({ 101 => 1, 102 => 2 })).to eq 3
    end

    specify "function called with a single ident" do
      function = parse("sum{101}").to_ast.to_proc
      expect(function.call({ 101 => 1, 102 => 2 })).to eq 1
    end

    specify "if function called with an ident list" do
      function = parse("if{101 102 a}").to_ast.to_proc
      expect(function.call({ 101 => true, 102 => 2, :a => 3 })).to eq 2
      expect(function.call({ 101 => false, 102 => 2, :a => 3 })).to eq 3
    end
  end
end
