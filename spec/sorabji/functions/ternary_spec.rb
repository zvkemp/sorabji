require_relative '../../spec_helper'

describe Sorabji::FunctionTernary do
  let(:object_true){{ 276 => 2000, 201 => 2001 }}
  let(:object_false){{ 276 => false, 201 => 2001, 202 => 1001 }}
  let(:object_blank){{ 201 => 2001, 202 => 1001 }}

  [
    ["if[{276} ({276} + 1) 1000]", 2001, 1000, "check presence of variable"],
    ["if[true 100 500]", 100, 100, "boolean true"],
    ["if[false 100 500]", 500, 500, "boolean false"],
    ["if{276 201 202}", 2001, 1001, "ident list"]
  ].each do |example, true_exp, false_exp, desc|
    describe desc do
      let(:ast){ parse(example).to_ast }
      let(:function){ ast.to_proc }

      specify { function[object_true].must_equal true_exp }
      specify { function[object_false].must_equal false_exp }
      specify { function[object_blank].must_equal false_exp }

    end
  end

end
