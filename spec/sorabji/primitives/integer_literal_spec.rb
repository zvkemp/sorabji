require_relative '../../spec_helper'

describe Sorabji::IntegerLiteral do
  let(:ast){ parse('123').to_ast }
  specify { ast.must_equal Sorabji::IntegerLiteral.new(123) }
  specify { ast.to_proc.call(Object.new).must_equal 123 }
end
