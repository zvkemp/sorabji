require_relative '../../spec_helper'

describe Sorabji::FunctionDefault do
  let(:expression){ "default[{276} {275} 101]" }
  let(:ast){ parse(expression).to_ast }
  let(:function){ ast.to_proc }

  [
    [{}, 101],
    [{ 276 => 201 }, 201],
    [{ 275 => 301 }, 301],
    [{ 276 => 201, 275 => 301 }, 201]
  ].each do |obj, expectation|
    specify do
      expect(function[obj]).to eq expectation
    end
  end

  specify do
    func = parse("default[{276} {275} 101]").to_ast.to_proc
    expect(func.call({})).to eq 101
  end
end
