module Sorabji
  class ObjectIdentifierNode < ASTNode
    def to_ast
      identifiers = ident.elements.map {|x| ObjectIdentifier.new(x.ident_e.to_ast.value) }
      if identifiers.size == 1
        identifiers.first
      else
        List.new(identifiers)
      end
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
end
