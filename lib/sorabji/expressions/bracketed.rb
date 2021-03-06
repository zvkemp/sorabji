module Sorabji
  class BracketedNode < ASTNode
    def to_ast
      Bracketed.new(content.to_ast)
    end
  end

  class Bracketed < Struct.new(:contents)
    def to_proc
      contents.to_proc
    end

    def object_identifiers
      contents.object_identifiers
    end
  end
end
