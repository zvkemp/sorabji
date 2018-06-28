require_relative '../../spec_helper'

describe Sorabji::StringLiteral do
  let(:ast){ parse('"hello"').to_ast }
  specify do
    expect(ast).to eq Sorabji::StringLiteral.new("hello")
  end
  specify do
    expect(ast.to_proc.call(Object.new)).to eq "hello"
  end

  specify "string containing valid Sorabji is escaped to a string" do
    str = %{default[11 12 13]}
    expect(parse(%{"#{str}"}).to_ast.to_proc.call(Object.new)).to eq str
  end
end
