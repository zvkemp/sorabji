require 'treetop'

module Sorabji
  class ASTNode < Treetop::Runtime::SyntaxNode; end

  class StatementNode < ASTNode
    def to_ast
      elements.map do |e|
        e.to_ast
      end
    end
  end

  class BracketedNode < ASTNode
    def to_ast
      Bracketed.new(content.to_ast)
    end
  end

  class Bracketed < Struct.new(:contents)
    def to_proc
      contents.to_proc
    end
  end

  class OperationNode < ASTNode
    def to_ast
      Operation.new(left.to_ast, right.to_ast, operator.to_ast)
    end
  end

  class Operation < Struct.new(:left, :right, :operator)
    def to_proc
      ->(r){ left.to_proc.call(r).send(operator.value, right.to_proc.call(r)) }
    end

    def inspect
      "{ #{left.inspect} #{operator.value} #{right.inspect} }"
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

  class VariableNode < ASTNode; end
  class Variable < Struct.new(:value); end



  class ObjectVariableNode < ASTNode; end
  class ObjectVariable < Struct.new(:value); end



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
