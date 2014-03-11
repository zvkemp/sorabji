require 'treetop'
module Sorabji
  class ASTNode < Treetop::Runtime::SyntaxNode; end

  class IntegerLiteralNode < ASTNode
    def to_ast
      IntegerLiteral.new(text_value.to_i)
    end
  end
  class IntegerLiteral < Struct.new(:value); end



  class ObjectIdentifierNode < ASTNode
    def to_ast
      ObjectIdentifier.new(number.to_ast.value)
    end
  end
  class ObjectIdentifier < Struct.new(:value); end

  class VariableNode < ASTNode; end
  class Variable < Struct.new(:value); end

  class ObjectVariableNode < ASTNode; end
  class ObjectVariable < Struct.new(:value); end
end
