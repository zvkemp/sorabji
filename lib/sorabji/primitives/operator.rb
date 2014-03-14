module Sorabji
  class OperatorNode < ASTNode
    def to_ast
      Operator.new(text_value.strip.to_sym)
    end
  end
  class Operator < Struct.new(:value)
  end
end
