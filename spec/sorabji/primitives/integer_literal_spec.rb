require_relative '../../spec_helper'

describe Sorabji::IntegerLiteral do
  let(:ast){ parse('123').to_ast }
  specify do
    expect(ast).to eq Sorabji::IntegerLiteral.new(123)
  end

  specify do
    expect(ast.to_proc.call(Object.new)).to eq 123
  end
end
