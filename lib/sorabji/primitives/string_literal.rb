module Sorabji
  class StringLiteralNode < ASTNode
    def to_ast
      StringLiteral.new(content.text_value)
    end
  end

  class StringLiteral < Struct.new(:value)
    def to_proc
      ->(*args){ value }
    end
  end
end
