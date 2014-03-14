require_relative '../spec_helper'

describe Sorabji::StackOperation::EnsureOperationPrecedence do
  let(:sub){ Sorabji::Operator.new(:-) }
  let(:mul){ Sorabji::Operator.new(:*) }

  specify do
    original_operands = [1, 2, 3]
    original_operators = [sub, mul]
    expected_operands = [1, Sorabji::StackOperation.new(operands: [2, 3], operators: [mul])]
    expected_operators = [sub]
    op = Sorabji::StackOperation::EnsureOperationPrecedence.new(original_operands, original_operators)
    new_ods, new_ops = *op.process
    new_ops.must_equal expected_operators
    new_ods.must_equal expected_operands
  end
end

__END__

1 - 2 * 3 + 4 * 5
[1 2 3 4 5][- * + *]

-:
[1][]              [2 3 4 5]
[1][-]

*:
[1 2][-]           [3 4 5]
[1 [2 3 *][-]    [4 5]

+:
[1 [2 3 *] 4][-]    [5]
[1 [2 3 *] 4][- +]  [5]

*:
[1 [2 3 *] 4 5][- +] []
[1 [2 3 *] [4 5 *]][- +] []
