require_relative '../../spec_helper'

describe Sorabji::Identifier do
  # this is no longer a valid part of the semantics, and will not
  # be parsed into the syntax tree.

  specify do
    expect { parse('var').to_ast }.to raise_error NoMethodError
  end
end
