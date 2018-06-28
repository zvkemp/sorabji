require_relative '../../spec_helper'


describe Sorabji::FunctionMatch do
  [
    ['match?["hello" "hello, world"]', {}, true, 'simple string match'],
    ['match?[1 [11 12 13]]', {}, true, 'string conversion match'],
    ['match?["hello" ["world" "cats"]]', {}, false, 'simple no match'],
    ['match?[{276} {277 278}]', { 276 => 101, 277 => 2, 278 => "101 spiders!" }, true, 'lookup match'],
    ['match?[{276} {277 278}]', { 276 => 101, 277 => 2, 278 => 3 }, false, 'lookup no match']
  ].each do |example, object, expectation, desc|
    describe desc do
      let(:function){ parse(example).to_ast.to_proc }
      specify do
        expect(function.call(object)).to eq expectation
      end
    end
  end
end
