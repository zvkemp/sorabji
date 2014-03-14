module Sorabji
  class IdentifierNode < ASTNode
    def to_ast
      Identifier.new(text_value.to_sym)
    end
  end

  class Identifier < Struct.new(:value)
    def to_proc
      ->(*args){ value }
    end
  end
end
