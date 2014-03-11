require 'treetop'
module Sorabji
  class ASTNode < Treetop::Runtime::SyntaxNode; end

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
  class IntegerLiteral < Struct.new(:value); end



  class ObjectIdentifierNode < ASTNode
    def to_ast
      ObjectIdentifier.new(ident.to_ast.value)
    end
  end
  class ObjectIdentifier < Struct.new(:value); end



  class VariableNode < ASTNode; end
  class Variable < Struct.new(:value); end



  class ObjectVariableNode < ASTNode; end
  class ObjectVariable < Struct.new(:value); end



  class IdentiferNode < ASTNode
    def to_ast
      Identifier.new(text_value.to_sym)
    end
  end
  class Identifier < Struct.new(:value); end
end
