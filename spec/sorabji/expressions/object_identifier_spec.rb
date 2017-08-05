require_relative '../../spec_helper'

describe "Identifiers" do
  let(:object) do
    {
      123 => 101,
      hello: "world",
      124 => 10.2,
      125 => "10.3",
      126 => 10.4
    }
  end
  describe Sorabji::ObjectIdentifier do

    [
      ["{123}", 123, 101],
      ["{hello}", :hello, "world"],
      ["{124}", 124, 10.2],
      ["{125}", 125, 10.3],
      ["{126}", 126, 10.4]
    ].each do |example, key, expectation|
      describe "object_identifier (#{example})" do
        let(:ast){ parse(example).to_ast }

        specify { ast.must_equal Sorabji::ObjectIdentifier.new(key) }
        specify { ast.to_proc.call(object).must_equal expectation }
      end
    end
  end

  describe Sorabji::ReferenceObjectIdentifier do
    let(:ref){ Object.new }
    let(:ast){ parse('{{year}}').to_ast }
    before do
      Sorabji::config do |sb|
        sb.reference_object_method = :reference_object
        sb.reference_object_whitelist << :year
      end

      allow(object).to receive(:reference_object) { ref }
      allow(ref).to receive(:year) { 2014 }
    end

    specify { ast.must_equal Sorabji::ReferenceObjectIdentifier.new(:year) }
    specify { ast.to_proc.call(object).must_equal 2014 }

    specify "non-whitelisted messages are intercepted" do
      function = parse("{{missing}}").to_ast.to_proc
      ->{ function.call(object) }.must_raise Sorabji::NoWhitelistedMethodError
    end
  end
end
