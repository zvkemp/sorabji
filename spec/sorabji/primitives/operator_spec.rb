require_relative '../../spec_helper'

describe Sorabji::Operator do
  # this is no longer a valid part of the semantics, and will not
  # be parsed into the syntax tree. Operators only exist within other expressions

  %w[+ - / *].each do |operator|
    specify do
      expect { parse(operator).to_ast }.to raise_error NoMethodError
    end
  end
end
