module Sorabji
  class StatementNode < ASTNode
    def to_ast
      elements.map(&:to_ast)
    end
  end

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

  class ObjectIdentifierNode < ASTNode
    def to_ast
      ObjectIdentifier.new(ident.to_ast.value)
    end
  end

  class ObjectIdentifier < Struct.new(:value)
    def to_proc
      ->(r){ r[value] }
    end

    def inspect
      "{#{value}}"
    end
  end

  class ReferenceObjectIdentifierNode < ASTNode
    def to_ast
      ReferenceObjectIdentifier.new(ident.to_ast.value)
    end
  end

  class ReferenceObjectIdentifier < Struct.new(:value)
    def to_proc
      ->(r){ r.reference_object.send(value) }
    end
  end

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

  class OperatorNode < ASTNode
    def to_ast
      Operator.new(text_value.strip.to_sym)
    end
  end

  class Operator < Struct.new(:value)
  end
end
