require_relative '../spec_helper'

describe Sorabji::Parser do
  # let(:parser){ Sorabji::Parser }
  let(:parser){ SorabjiParser.new }
  let(:parse){ -> (str) { parser.parse(str) } }
  specify { parser.wont_be_nil }
  specify { parser.must_be_instance_of SorabjiParser }

  describe 'errors' do
  end


  describe 'simple expressions' do
    specify "parsing an integer" do
      parse_tree = parse['123']
      parse_tree.to_ast.must_equal [Sorabji::IntegerLiteral.new(123)]
    end

    specify "object identifier" do
      parse_tree = parse['{123}']
      parse_tree.to_ast.must_equal [Sorabji::ObjectIdentifier.new(123)]
    end

    specify "identifier" do
      parse_tree = parse['external_id']
      puts parse_tree.inspect
      parse_tree.to_ast.must_equal [Sorabji::Identifier.new(:external_id)]
    end

    specify "object symbol ident" do
      parse_tree = parse['{external_id}']
      parse_tree.to_ast.must_equal [Sorabji::ObjectIdentifier.new(:external_id)]

    end
  end
end
