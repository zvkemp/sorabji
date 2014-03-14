require_relative '../../spec_helper'

describe Sorabji::StringLiteral do
  let(:ast){ parse('"hello"').to_ast }
  specify { ast.must_equal Sorabji::StringLiteral.new("hello") }
  specify { ast.to_proc.call(Object.new).must_equal "hello" }

  specify "string containing valid Sorabji is escaped to a string" do
    str = %{default[11 12 13]}
    parse(%{"#{str}"}).to_ast.to_proc.call(Object.new).must_equal str
  end
end
