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
      parse_tree.to_ast.must_equal [Sorabji::Identifier.new(:external_id)]
    end

    specify "object symbol ident" do
      parse_tree = parse '{external_id}'
      parse_tree.to_ast.must_equal [Sorabji::ObjectIdentifier.new(:external_id)]
    end

    specify "reference object symbol ident" do
      parse_tree = parse '{{year}}'
      parse_tree.to_ast.must_equal [Sorabji::ReferenceObjectIdentifier.new(:year)]
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
      ast = parse('external_id').to_ast[0]
      ast.to_proc.call(:anything, :at, :all).must_equal :external_id
    end

    specify "reference object identifier" do
      stub(object).reference_object { reference_object }
      ast = parse('{{year}}').to_ast[0]
      ast.to_proc.call(object).must_equal 2014
    end
  end
end
