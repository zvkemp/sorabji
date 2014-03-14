require 'treetop'

module Sorabji
  class Treetop::Runtime::SyntaxNode
    def to_ast
      nil
    end
  end

  class ASTNode < Treetop::Runtime::SyntaxNode; end
  require 'sorabji/primitives/statement'
  require 'sorabji/primitives/integer_literal'
  require 'sorabji/primitives/string_literal'
  require 'sorabji/primitives/identifier'
  require 'sorabji/primitives/operator'

end
