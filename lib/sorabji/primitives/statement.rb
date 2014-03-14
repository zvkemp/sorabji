module Sorabji
  class StatementNode < ASTNode
    def to_ast
      elements.map(&:to_ast)
    end
  end
end
