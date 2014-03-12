require 'treetop'

module Sorabji
  class Treetop::Runtime::SyntaxNode
    def to_ast
      nil
    end
  end

  class ASTNode < Treetop::Runtime::SyntaxNode; end
end
