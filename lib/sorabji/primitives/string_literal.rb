module Sorabji
  class StringLiteralNode < ASTNode
    def to_ast
      StringLiteral.new(content.text_value)
    end
  end

  class StringLiteral < Literal
    def to_proc
      ->(*args){ value }
    end
  end
end
