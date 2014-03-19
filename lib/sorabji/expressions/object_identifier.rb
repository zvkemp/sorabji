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
      ->(r){ r.send(reference_object_method).send(whitelist(value)) }
    end

    def reference_object_method
      Sorabji::config.reference_object_method
    end
    
    def whitelist(value)
      return value if Sorabji::config.reference_object_whitelist.include?(value)
      raise Sorabji::NoWhitelistedMethodError, "`#{value}` is not permitted."
    end

  end

  class NoWhitelistedMethodError < NoMethodError
  end
end
