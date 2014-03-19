module Sorabji
  class IntegerLiteralNode < ASTNode
    def to_ast
      IntegerLiteral.new(text_value.to_i)
    end
  end

  class IntegerLiteral < Struct.new(:value)
    def to_proc
      ->(*args){ value }
    end

    def inspect
      value
    end
  end
end
